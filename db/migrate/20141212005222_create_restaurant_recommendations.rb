class CreateRestaurantRecommendations < ActiveRecord::Migration
  def change
    create_table :restaurant_recommendations do |t|
      t.integer :restaurant_id
      t.integer :user_id
      t.decimal :overall_rating
      t.decimal :budget_rating
      t.decimal :distance_rating
      t.decimal :uniqueness_rating

      t.timestamps
    end
  end
end
