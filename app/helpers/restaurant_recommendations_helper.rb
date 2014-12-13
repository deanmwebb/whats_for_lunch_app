module RestaurantRecommendationsHelper


  def self.calculate_distance_index(restaurant, weights)
    distance_index = 0
    distance_miles = get_distance_in_miles(restaurant)
    distance_index = (10.0 - distance_miles)*weights[:distance] unless ((10.0 - distance_miles) < 0)
  end

  def self.get_distance_in_miles(restaurant)
    distance_meters = @loaded_user_distances.where("user_id = ? AND  restaurant_id = ?", current_user.id, restaurant.id).first.nil? ? 15 : @loaded_user_distances.where("user_id = ? AND  restaurant_id = ?", current_user.id, restaurant.id).first.distance_from_user
    logger.info "DISTANCE IN MILES FROM USER #{current_user.username} TO RESTAURANT #{restaurant.address} IS  #{distance_meters/1609.0}"
    distance_miles = (distance_meters/1609.0)
  end

  def self.calculate_cost_index(restaurant, weights)
    2*(5-restaurant.cost)*weights[:cost]
  end

  def self.calculate_ratings_index(restaurant, weights)
    2*restaurant.rating*weights[:ratings]
  end

  def self.calculate_uniqueness_index(restaurant, weights)
    uniqueness_index = 0
    total_times_attended = @loaded_attended_restaurants.where("user_id = ? AND  restaurant_id = ?", current_user.id, restaurant.id).count
    uniqueness_index = (10 - total_times_attended)*weights[:times_attended] unless ((10.0 - total_times_attended) < 0)
  end

  def self.calculate_preferred_cuisine_index(restaurant, weights)
    if current_user.preferred_cuisine.downcase == restaurant.cuisine.downcase
      preferred_cuisine_index = 10*weights[:preferred_cuisine]
    else
      preferred_cuisine_index = 0*weights[:preferred_cuisine]
    end
  end
end
