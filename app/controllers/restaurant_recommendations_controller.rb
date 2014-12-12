class RestaurantRecommendationsController < ApplicationController
  before_action :set_restaurant_recommendation, only: [:show, :edit, :update, :destroy]

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
  def create
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
  end

  # PATCH/PUT /restaurant_recommendations/1
  # PATCH/PUT /restaurant_recommendations/1.json
  def update
    respond_to do |format|
      if @restaurant_recommendation.update(restaurant_recommendation_params)
        format.html { redirect_to @restaurant_recommendation, notice: 'Restaurant recommendation was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant_recommendation }
      else
        format.html { render :edit }
        format.json { render json: @restaurant_recommendation.errors, status: :unprocessable_entity }
      end
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_recommendation_params
      params.require(:restaurant_recommendation).permit(:restaurant_id, :user_id, :overall_rating, :budget_rating, :distance_rating, :uniqueness_rating)
    end
end
