class Course < ActiveRecord::Base
	def uploaded
		update_attribute(:url, "Done")
	end
end
