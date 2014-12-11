require 'google_places'
require 'net/http'

class RestaurantsController < ApplicationController

  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :load_restaurants_from_google_api, only: [:index]

  # GET /restaurants
  # GET /restaurants.json
  @google_api_key = "AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY"
  @log_places = lambda do |place|
    logger.info "Place: #{place["name"].capitalize}"
    logger.info "Address: #{place["formatted_address"]}"
    logger.info "Rating: #{place["rating"]}"
    logger.info "Latitude: #{place["lat"]}"
    logger.info "Longitude: #{place["lng"]}"
    logger.info "Types: #{place["types"]}"

    3.times{logger.info ""}
  end


  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create(params = {})

    if params.length == 0
      @restaurant = Restaurant.new(restaurant_params)
        respond_to do |format|
      if @restaurant.save
        user_distance_data = calculate_distance_using_google_api({"formatted_address" => current_user.address},{"formatted_address" => @restaurant.address})
        UserDistance.create(user_id: current_user[:id], restaurant_id: @restaurant[:id], distance_from_user: user_distance_data[:distance_from_user], drive_time_for_user: user_distance_data[:drive_time_for_user])

        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end

    end
  else
    #Preloading Database With Data from Google API
     @restaurant = Restaurant.new(name: params[:name], address: params[:address], cost: params[:cost], rating: params[:rating] , cuisine: params[:cuisine])
     @restaurant.save 

     logger.info "INFO: Logging User Distance to Database... user_id: #{current_user[:id]}, restaurant_id: #{@restaurant[:id]}, distance_from_user: #{params[:distance_from_user]} Meters, drive_time_for_user: #{params[:drive_time_for_user]} Seconds"
     UserDistance.create(user_id: current_user[:id], restaurant_id: @restaurant[:id], distance_from_user: params[:distance_from_user], drive_time_for_user: params[:drive_time_for_user])
   end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
    
    def load_restaurants_from_google_api
      #if @places.nil?
          logger.info "Querying Google API for Places near #{current_user.address}..."

            #Get Home Address
            query_home_address

            #Get Nearby Places
            query_nearby_places

          @places.each do |place|

            distance = calculate_distance_using_google_api(@home_address_gps, place)
            logger.info "Distance/Duration between two points: #{distance}"

            creation_params = {
              name: place["name"].capitalize,
              address: place["formatted_address"],
              rating: place["rating"].to_f,
              cuisine: place["types"].first.gsub("_"," ").split()[0].capitalize,
              cost: place["price_level"].nil? ? 3 : place["price_level"].next,
              distance_from_user: distance[:distance_from_user],
              drive_time_for_user: distance[:drive_time_for_user]
            }

            if Restaurant.where(name: creation_params[:name]).first.nil? && Restaurant.where(address: creation_params[:address]).first.nil?
                  create(creation_params)
          end
        end
      #end
     end

       

    private

    def query_home_address
        uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
        params = { 
          :key => "AIzaSyAw-ItKGrTc6KTfnXwNa2s9KixqrKHVl1c", 
          :query => current_user.address 
        }
        uri.query = URI.encode_www_form(params)

        res = Net::HTTP.get_response(uri)

       logger.info "Response from Querying Home: #{res.body}"

       @home_address_gps = JSON.parse(res.body)["results"].first
     end

     def query_nearby_places
            uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
            params = { 
              key: "AIzaSyBZzPpygsuj-so-IUWVI87GTrWRQD2TDvU", 
              query: "Places near #{current_user.address}",
              types: "restaurant|food",
              radius: 16093
            }
          uri.query = URI.encode_www_form(params)

          res = Net::HTTP.get_response(uri)
         logger.info "Response from Querying Places: #{res.body}"

         @places = JSON.parse(res.body)["results"]
        end

        def retry_collecting_places(next_token)
            uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
            params = { 
            pagetoken: next_token,
            key: "AIzaSyBZzPpygsuj-so-IUWVI87GTrWRQD2TDvU"
          }
          uri.query = URI.encode_www_form(params)
          res = Net::HTTP.get_response(uri)

          logger.info "Response from EXTENDED QUERY: #{JSON.parse(res.body)}"
          temp = JSON.parse(res.body)["results"]
          logger.info "Temp class: #{temp.class} Temp Size: #{temp.size}"

          temp.each do |extended_result|
            @places.push(extended_result)
          end

        next_token = JSON.parse(res.body)["next_page_token"]
        end

     def calculate_distance_using_google_api(origin_address_gps, destination_address_gps)
       logger.info "Using Google Maps API to Calculate Distance between #{origin_address_gps["formatted_address"]} and #{destination_address_gps["formatted_address"]}"
       uri = URI('https://maps.googleapis.com/maps/api/distancematrix/json')

       params = { 
            origins: "#{origin_address_gps["formatted_address"]}",
            destinations: "#{destination_address_gps["formatted_address"]}",  
            key: "AIzaSyBZzPpygsuj-so-IUWVI87GTrWRQD2TDvU",
            mode: "driving"
          }

          uri.query = URI.encode_www_form(params)

          res = Net::HTTP.get_response(uri)
         logger.info "Response from Google Maps API: #{res.body}"

         @distance_result = {
          distance_from_user: JSON.parse(res.body)["rows"].first["elements"].first["distance"]["value"],
          drive_time_for_user: JSON.parse(res.body)["rows"].first["elements"].first["duration"]["value"]
        }
         logger.info "Distance Result: #{@distance_result} Meters | Seconds"
         @distance_result
       end

    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:id, :name, :address, :cuisine, :cost, :rating)
    end
end
