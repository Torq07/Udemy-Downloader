class Course < ActiveRecord::Base
	has_many :sections, dependent: :destroy
	def uploaded
		update_attribute(:upload, 1)
	end
end
