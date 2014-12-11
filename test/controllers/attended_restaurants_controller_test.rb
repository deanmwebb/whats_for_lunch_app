require 'test_helper'

class AttendedRestaurantsControllerTest < ActionController::TestCase
  setup do
    @attended_restaurant = attended_restaurants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:attended_restaurants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create attended_restaurant" do
    assert_difference('AttendedRestaurant.count') do
      post :create, attended_restaurant: { date_attended: @attended_restaurant.date_attended, restaurant_id: @attended_restaurant.restaurant_id, user_id: @attended_restaurant.user_id }
    end

    assert_redirected_to attended_restaurant_path(assigns(:attended_restaurant))
  end

  test "should show attended_restaurant" do
    get :show, id: @attended_restaurant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @attended_restaurant
    assert_response :success
  end

  test "should update attended_restaurant" do
    patch :update, id: @attended_restaurant, attended_restaurant: { date_attended: @attended_restaurant.date_attended, restaurant_id: @attended_restaurant.restaurant_id, user_id: @attended_restaurant.user_id }
    assert_redirected_to attended_restaurant_path(assigns(:attended_restaurant))
  end

  test "should destroy attended_restaurant" do
    assert_difference('AttendedRestaurant.count', -1) do
      delete :destroy, id: @attended_restaurant
    end

    assert_redirected_to attended_restaurants_path
  end
end
