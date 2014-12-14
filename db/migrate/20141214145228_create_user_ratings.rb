class CreateUserRatings < ActiveRecord::Migration
  def change
    create_table :user_ratings do |t|
      t.integer :restaurant_id
      t.integer :user_id
      t.boolean :default?
      t.integer :rating

      t.timestamps
    end
  end
end
