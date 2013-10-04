class Movie < ActiveRecord::Base

	def self.get_all_ratings
		allRatings = [['G',true],['PG',true],['PG-13',true],['R',true]]
		return allRatings
	end

end
