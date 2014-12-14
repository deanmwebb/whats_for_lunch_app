class UserDistancesController < ApplicationController
  before_action :set_user_distance, only: [:show, :edit, :update, :destroy]
  before_action :load_existing_restaurants
  helper_method :load_existing_restaurants

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
     raise "Could not save User Distance Data! " unless @user_distance.save
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

    def load_existing_restaurants  
      Restaurant.all.each do |place|
          creation_params = {
              user_id: current_user.id,
              restaurant_id: place[:id]
            }

        if UserDistance.where("user_id = ? AND  restaurant_id = ?", creation_params[:user_id], creation_params[:restaurant_id]).first.nil?

          logger.info "Calcuating Distance for all restaurants in database for #{current_user.username}..."
          

            distance = RestaurantsHelper.calculate_distance_using_google_api({"formatted_address" => current_user.address}, {"formatted_address" => place.address})
            logger.info "Distance/Duration between two points: #{distance}"

            creation_params[:distance_from_user] = distance[:distance_from_user]
            creation_params[:drive_time_for_user] = distance[:drive_time_for_user]
            
            create(creation_params)
          end
        end
     end


    # Never trust parameters from the scary internet, only allow the white list through.
    def user_distance_params
      params.require(:user_distance).permit(:user_id, :restaurant_id, :distance_from_user, :drive_time_for_user)
    end
end
