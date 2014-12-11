class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :cuisine
      t.integer :cost
      t.decimal :rating
      t.timestamp :last_attended

      t.timestamps
    end
  end
end
