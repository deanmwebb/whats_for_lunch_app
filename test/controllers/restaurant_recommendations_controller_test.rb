require 'test_helper'

class RestaurantRecommendationsControllerTest < ActionController::TestCase
  setup do
    @restaurant_recommendation = restaurant_recommendations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:restaurant_recommendations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create restaurant_recommendation" do
    assert_difference('RestaurantRecommendation.count') do
      post :create, restaurant_recommendation: { budget_rating: @restaurant_recommendation.budget_rating, distance_rating: @restaurant_recommendation.distance_rating, overall_rating: @restaurant_recommendation.overall_rating, restaurant_id: @restaurant_recommendation.restaurant_id, uniqueness_rating: @restaurant_recommendation.uniqueness_rating, user_id: @restaurant_recommendation.user_id }
    end

    assert_redirected_to restaurant_recommendation_path(assigns(:restaurant_recommendation))
  end

  test "should show restaurant_recommendation" do
    get :show, id: @restaurant_recommendation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @restaurant_recommendation
    assert_response :success
  end

  test "should update restaurant_recommendation" do
    patch :update, id: @restaurant_recommendation, restaurant_recommendation: { budget_rating: @restaurant_recommendation.budget_rating, distance_rating: @restaurant_recommendation.distance_rating, overall_rating: @restaurant_recommendation.overall_rating, restaurant_id: @restaurant_recommendation.restaurant_id, uniqueness_rating: @restaurant_recommendation.uniqueness_rating, user_id: @restaurant_recommendation.user_id }
    assert_redirected_to restaurant_recommendation_path(assigns(:restaurant_recommendation))
  end

  test "should destroy restaurant_recommendation" do
    assert_difference('RestaurantRecommendation.count', -1) do
      delete :destroy, id: @restaurant_recommendation
    end

    assert_redirected_to restaurant_recommendations_path
  end
end
