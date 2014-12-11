class CreateUserDistances < ActiveRecord::Migration
  def change
    create_table :user_distances do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :distance_from_user
      t.integer :drive_time_for_user

      t.timestamps
    end
  end
end
