class RestaurantRecommendationsController < ApplicationController

  before_action :set_restaurant_recommendation, only: [:show, :edit, :update, :destroy]
  
    helper_method :load_api_data_path 
    helper_method :load_distances_path 
    before_action :load_data

  # GET /restaurant_recommendations
  # GET /restaurant_recommendations.json
  def index
    @restaurant_recommendations = RestaurantRecommendation.all
  end

  # GET /restaurant_recommendations/1
  # GET /restaurant_recommendations/1.json
  def show
  end

  # GET /restaurant_recommendations/new
  def new
    @restaurant_recommendation = RestaurantRecommendation.new
  end

  # GET /restaurant_recommendations/1/edit
  def edit
  end

  # POST /restaurant_recommendations
  # POST /restaurant_recommendations.json
  def create(params = {})

    if params.length == 0
      @restaurant_recommendation = RestaurantRecommendation.new(restaurant_recommendation_params)

      respond_to do |format|
        if @restaurant_recommendation.save
          format.html { redirect_to @restaurant_recommendation, notice: 'Restaurant recommendation was successfully created.' }
          format.json { render :show, status: :created, location: @restaurant_recommendation }
        else
          format.html { render :new }
          format.json { render json: @restaurant_recommendation.errors, status: :unprocessable_entity }
        end
      end
    else
      @restaurant_recommendation = RestaurantRecommendation.new({user_id: params[:user_id], restaurant_id: params[:restaurant_id], overall_rating: params[:overall_rating], budget_rating: params[:budget_rating], distance_rating: params[:distance_rating], uniqueness_rating: params[:uniqueness_rating] })
      @restaurant_recommendation.save
  end
  end

  # PATCH/PUT /restaurant_recommendations/1
  # PATCH/PUT /restaurant_recommendations/1.json
  def update(params = {})
    if params.length == 0
      respond_to do |format|
        if @restaurant_recommendation.update(restaurant_recommendation_params)
          format.html { redirect_to @restaurant_recommendation, notice: 'Restaurant recommendation was successfully updated.' }
          format.json { render :show, status: :ok, location: @restaurant_recommendation }
        else
          format.html { render :edit }
          format.json { render json: @restaurant_recommendation.errors, status: :unprocessable_entity }
        end
      end
    else
      logger.info "PARAMS PASSED INTO UPDATE ACTION FOR RESTAURANT_RECOMMENDATIONS #{params}"
      RestaurantRecommendation.where(user_id: params[:user_id], restaurant_id: params[:restaurant_id]).first.update({ user_id: params[:user_id], restaurant_id: params[:restaurant_id], overall_rating: params[:overall_rating], budget_rating: params[:budget_rating], distance_rating: params[:distance_rating], uniqueness_rating: params[:uniqueness_rating]})
    end
  end

  # DELETE /restaurant_recommendations/1
  # DELETE /restaurant_recommendations/1.json
  def destroy
    @restaurant_recommendation.destroy
    respond_to do |format|
      format.html { redirect_to restaurant_recommendations_url, notice: 'Restaurant recommendation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant_recommendation
      @restaurant_recommendation = RestaurantRecommendation.find(params[:id])
    end

    def load_data

      @loaded_restaurants = Restaurant.all
      @loaded_user_distances = UserDistance.all
      @loaded_attended_restaurants = AttendedRestaurant.all

      @loaded_restaurants.each { |restaurant|

        overall_rating = calculate_overall_ranking(restaurant)
        budget_rating = 0.0
        distance_rating = 0.0
        uniqueness_rating = 0.0


        params = {
          user_id: current_user.id, restaurant_id: restaurant.id, 
          overall_rating: overall_rating, budget_rating: budget_rating, 
          distance_rating: distance_rating, uniqueness_rating: uniqueness_rating
        }

        logger.info "PARAMS PASSED INTO CREATE ACTION FOR RESTAURANT_RECOMMENDATIONS #{params}"

        if RestaurantRecommendation.where("user_id = ? AND restaurant_id = ?", current_user.id, restaurant.id).first.nil?
          create(params)
        else
          update(params)
        end
      }
    end

    def calculate_overall_ranking(restaurant)
      weights = {
        cost: 0.30,
        distance: 0.20,
        ratings: 0.30,
        times_attended: 0.10,
        preferred_cuisine: 0.10
      }

      distance = @loaded_user_distances.where("user_id = ? AND  restaurant_id = ?", current_user.id, restaurant.id).first.nil? ? 15 : UserDistance.where("user_id = ? AND  restaurant_id = ?", current_user.id, restaurant.id).first.distance_from_user

      ratings_index = 2*restaurant.rating*weights[:ratings]
      cost_index = 2*(5-restaurant.cost)*weights[:cost]

      distance_index = 0
      distance_index = ((10.0 - (distance/1609.0)))*weights[:cost] unless ((10.0 - (distance/1609.0)) < 0)

      if current_user.preferred_cuisine.downcase == restaurant.cuisine.downcase
        preferred_cuisine_index = 10*weights[:preferred_cuisine]
      else
        preferred_cuisine_index = 0*weights[:preferred_cuisine]
      end

      uniqueness_index = 0
      total_times_attended = @loaded_attended_restaurants.where("user_id = ? AND  restaurant_id = ?", current_user.id, restaurant.id).size
      uniqueness_index = (10 - total_times_attended)*weights[:times_attended] unless ((10.0 - total_times_attended) < 0)

      array = [ratings_index, cost_index, distance_index, uniqueness_index, preferred_cuisine_index]

      array.map{|x| x.to_f}.reduce(:+)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_recommendation_params
      params.require(:restaurant_recommendation).permit(:restaurant_id, :user_id, :overall_rating, :budget_rating, :distance_rating, :uniqueness_rating)
    end
end
