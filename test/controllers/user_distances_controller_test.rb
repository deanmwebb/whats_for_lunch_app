require 'test_helper'

class UserDistancesControllerTest < ActionController::TestCase
  setup do
    @user_distance = user_distances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_distances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_distance" do
    assert_difference('UserDistance.count') do
      post :create, user_distance: { distance_from_user: @user_distance.distance_from_user, drive_time_for_user: @user_distance.drive_time_for_user, restaurant_id: @user_distance.restaurant_id, user_id: @user_distance.user_id }
    end

    assert_redirected_to user_distance_path(assigns(:user_distance))
  end

  test "should show user_distance" do
    get :show, id: @user_distance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_distance
    assert_response :success
  end

  test "should update user_distance" do
    patch :update, id: @user_distance, user_distance: { distance_from_user: @user_distance.distance_from_user, drive_time_for_user: @user_distance.drive_time_for_user, restaurant_id: @user_distance.restaurant_id, user_id: @user_distance.user_id }
    assert_redirected_to user_distance_path(assigns(:user_distance))
  end

  test "should destroy user_distance" do
    assert_difference('UserDistance.count', -1) do
      delete :destroy, id: @user_distance
    end

    assert_redirected_to user_distances_path
  end
end
