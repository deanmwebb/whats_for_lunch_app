class Restaurant < ActiveRecord::Base
	validates :name, presence: true,
					 uniqueness: true
	validates :cuisine, presence: true
	validates :address, presence: true, 
						uniqueness: true
	validates :cost, presence: true,
					 length: { minimum: 1, maximum: 5 }
	validates :rating, presence: true,
					   length: { minimum: 1, maximum: 5 }

	belongs_to :attended_restaurant
	belongs_to :user_distance
	belongs_to :user_rating
end
