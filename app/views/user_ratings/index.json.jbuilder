json.array!(@user_ratings) do |user_rating|
  json.extract! user_rating, :id, :restaurant_id, :user_id, :default?, :rating
  json.url user_rating_url(user_rating, format: :json)
end
