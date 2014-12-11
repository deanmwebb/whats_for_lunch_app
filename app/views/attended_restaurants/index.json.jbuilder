json.array!(@attended_restaurants) do |attended_restaurant|
  json.extract! attended_restaurant, :id, :restaurant_id, :user_id, :date_attended
  json.url attended_restaurant_url(attended_restaurant, format: :json)
end
