class Restaurant < ActiveRecord::Base
	validates :name, presence: true
	validates :cuisine, presence: true
	validates :address, presence: true
	validates :cost, presence: true,
					 length: { minimum: 1, maximum: 5 }
	validates :rating, presence: true,
					   length: { minimum: 1, maximum: 5 }
end
