class Dewey < ApplicationRecord

	def self.get_genre dewey_code
		Dewey.find_by(code: dewey_code/100)
	end
end
