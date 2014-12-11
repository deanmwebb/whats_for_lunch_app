json.array!(@user_distances) do |user_distance|
  json.extract! user_distance, :id, :user_id, :restaurant_id, :distance_from_user, :drive_time_for_user
  json.url user_distance_url(user_distance, format: :json)
end
