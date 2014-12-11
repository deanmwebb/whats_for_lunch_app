require 'google_places'
require 'net/http'

class RestaurantsController < ApplicationController

  before_action :create_google_api_client, only: [:index, :show]
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  before_action :load_restaurants_from_google_api

  # GET /restaurants
  # GET /restaurants.json
  #@google_api_key = "AIzaSyDNMJwNQiqU1-0KHZXz6omHpzCaqY5gKCs"
  @google_api_key = "AIzaSyA0zgbkEn__stJJwtR7f9JDxCYrQZC__QY"
  @log_places = lambda do |place|
    logger.info "Place: #{place.name.capitalize}"
    logger.info "Address: #{place.formatted_address}"
    logger.info "Rating: #{place.rating}"
    logger.info "Latitude: #{place.lat}"
    logger.info "Longitude: #{place.lng}"
    logger.info "Types: #{place.types}"

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
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
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
      logger.info "Querying Google API for Places near #{current_user.address}..."

      @home_address_gps = @client.spots_by_query("270 17th St NW, Atlanta GA, 30324").first unless current_user.address.empty?
      @places = @client.spots_by_query("Places near #{current_user.address}", :types => ['restaurant', 'food'], :exclude => ['lodging', 'grocery_or_supermarket'], :radius => 16093) # 10 mile radius

      @places.each do |place|
        @log_places.call(place)
        distance = calculate_distance_using_google_api(@home_address_gps, place)
        logger.info "Distance between two points: distance"
      end
     end

     def calculate_distance_using_google_api(origin_address_gps, destination_address_gps)

      #Can't use Maps API, asked me to pay
      # logger.info "Using Google Maps API to Calculate Distance between #{origin_address_gps.formatted_address} and #{destination_address_gps.formatted_address}"

      # url = URI.parse("https://maps.googleapis.com/maps/api/distancematrix/json?"\
      #                 "origins=#{origin_address_gps.lat},#{origin_address_gps.lng}"\
      #                 "&destinations=#{destination_address_gps.lat},#{destination_address_gps.lng}"\
      #                 "&key=#{@google_api_key}"\
      #                 "&mode=driving"\
      #                 "&departure_time=now")
      # req = Net::HTTP::Get.new(url.to_s)
      # res = Net::HTTP.start(url.host, url.port) do |http|
      #   http.request(req)
      # end

      # logger.info "#{res.body}"


      #Calculating Distance using Haversine Formula
      distance [origin_address_gps.lat, origin_address_gps.lng],[destination_address_gps.lat, destination_address_gps.lng]
     end

    private

    def create_google_api_client
      @client = GooglePlaces::Client.new(@google_api_key)
    end

    def distance a, b
      rad_per_deg = Math::PI/180  # PI / 180
      rkm = 6371                  # Earth radius in kilometers
      rm = rkm * 1000             # Radius in meters

      dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
      dlat_rad = (b[0]-a[0]) * rad_per_deg

      lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
      lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

      rm * c # Delta in meters
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :address, :cuisine, :cost, :rating)
    end
end
