class UserDistancesController < ApplicationController
  before_action :set_user_distance, only: [:show, :edit, :update, :destroy]

  # GET /user_distances
  # GET /user_distances.json
  def index
    @user_distances = UserDistance.all
  end

  # GET /user_distances/1
  # GET /user_distances/1.json
  def show
  end

  # GET /user_distances/new
  def new
    @user_distance = UserDistance.new
  end

  # GET /user_distances/1/edit
  def edit
  end

  # POST /user_distances
  # POST /user_distances.json
  def create(params)
    @user_distance = UserDistance.new(user_distance_params)

     if params.length == 0
        @user_distance = UserDistance.new(user_distance_params)

      respond_to do |format|
        if @user_distance.save
          format.html { redirect_to @user_distance, notice: 'User distance was successfully created.' }
          format.json { render :show, status: :created, location: @user_distance }
        else
          format.html { render :new }
          format.json { render json: @user_distance.errors, status: :unprocessable_entity }
        end
      end
  else
    #Preloading Database With Data from Google API
     @user_distance = UserDistance.new(user_id: params[:user_id], restaurant_id: params[:restaurant_id], distance_from_user: params[:distance_from_user], drive_time_for_user: params[:drive_time_for_user])
     @user_distance.save 
   end
  end

  # PATCH/PUT /user_distances/1
  # PATCH/PUT /user_distances/1.json
  def update
    respond_to do |format|
      if @user_distance.update(user_distance_params)
        format.html { redirect_to @user_distance, notice: 'User distance was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_distance }
      else
        format.html { render :edit }
        format.json { render json: @user_distance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_distances/1
  # DELETE /user_distances/1.json
  def destroy
    @user_distance.destroy
    respond_to do |format|
      format.html { redirect_to user_distances_url, notice: 'User distance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_distance
      @user_distance = UserDistance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_distance_params
      params.require(:user_distance).permit(:user_id, :restaurant_id, :distance_from_user, :drive_time_for_user)
    end
end
