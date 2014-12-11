class CreateAttendedRestaurants < ActiveRecord::Migration
  def change
    create_table :attended_restaurants do |t|
      t.integer :restaurant_id
      t.integer :user_id
      t.integer :distance_from_user
      t.integer :drive_time_for_user
      t.timestamp :date_attended

      t.timestamps
    end
  end
end
