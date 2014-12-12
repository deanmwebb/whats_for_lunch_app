json.array!(@restaurant_recommendations) do |restaurant_recommendation|
  json.extract! restaurant_recommendation, :id, :restaurant_id, :user_id, :overall_rating, :budget_rating, :distance_rating, :uniqueness_rating
  json.url restaurant_recommendation_url(restaurant_recommendation, format: :json)
end
