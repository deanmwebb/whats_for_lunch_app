json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :id, :name, :address, :cuisine, :cost, :rating, :last_attended
  json.url restaurant_url(restaurant, format: :json)
end
