class CreateAttendedRestaurants < ActiveRecord::Migration
  def change
    create_table :attended_restaurants do |t|
      t.integer :restaurant_id
      t.integer :user_id
      t.timestamp :date_attended

      t.timestamps
    end
  end
end
