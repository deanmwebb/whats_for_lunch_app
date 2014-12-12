class AttendedRestaurantsController < ApplicationController
  before_action :set_attended_restaurant, only: [:show, :edit, :update, :destroy]
  autocomplete :restaurants, :name

  # GET /attended_restaurants
  # GET /attended_restaurants.json
  def index
    @attended_restaurants = AttendedRestaurant.all
  end

  # GET /attended_restaurants/1
  # GET /attended_restaurants/1.json
  def show
  end

  # GET /attended_restaurants/new
  def new
    @attended_restaurant = AttendedRestaurant.new
  end

  # GET /attended_restaurants/1/edit
  def edit
  end

  # POST /attended_restaurants
  # POST /attended_restaurants.json
  def create(params = {})

    if params.length == 0
      @attended_restaurant = AttendedRestaurant.new(attended_restaurant_params)
    else

      @attended_restaurant = AttendedRestaurant.new(params)
    end

    respond_to do |format|
      if @attended_restaurant.save
        format.html { redirect_to @attended_restaurant, notice: 'Attended restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @attended_restaurant }
      else
        format.html { render :new }
        format.json { render json: @attended_restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attended_restaurants/1
  # PATCH/PUT /attended_restaurants/1.json
  def update
    respond_to do |format|
      if @attended_restaurant.update(attended_restaurant_params)
        format.html { redirect_to @attended_restaurant, notice: 'Attended restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @attended_restaurant }
      else
        format.html { render :edit }
        format.json { render json: @attended_restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attended_restaurants/1
  # DELETE /attended_restaurants/1.json
  def destroy
    @attended_restaurant.destroy
    respond_to do |format|
      format.html { redirect_to attended_restaurants_url, notice: 'Attended restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_attended_restaurant
    @attended_restaurant = AttendedRestaurant.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attended_restaurant_params
    params.require(:attended_restaurant).permit(:restaurant_id, :user_id, :date_attended)
  end
end
