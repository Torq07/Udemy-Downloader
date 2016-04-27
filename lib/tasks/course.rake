require 'CourseLinks'
desc "Uploading course"
task :upload => :environment do
	# output=`udemy-dl -u #{ENV['UDEMY_NAME']} -p #{ENV['UDEMY_PASSWORD']} --lecture-start 1 --lecture-end 20 #{ENV['COURSE_URL']} -l`
	# File.open("title_#{ENV['NAME']}.txt",'wb+'){|f| f.puts(output.split("\r\n\r\n")[1])}
	# `udemy-dl -u #{ENV['UDEMY_NAME']} -p #{ENV['UDEMY_PASSWORD']} --lecture-start 1 --lecture-end 20 #{ENV['COURSE_URL']} -s`
	course = Course.find(ENV['COURSE_ID'])
	course.uploaded
	links=CourseLinks.new("#{Rails.root}/#{ENV['NAME'].downcase}.txt","#{Rails.root}/title_#{ENV['NAME']}.txt")
	links.get_data
	# links.download_pages
	links.get_id(ENV['COURSE_URL'],ENV['UDEMY_NAME'],ENV['UDEMY_PASSWORD'])
	# links.download_pages(ENV['UDEMY_NAME'],ENV['UDEMY_PASSWORD'])
	# links.listing.each do |chapter,v|
	# 	chapter=course.sections.create(name:chapter)
	# 		v.each do |lecture,link|
	# 				puts lecture
	# 				puts links
	# 				# type=nil
					
	# 			 chapter.tutorials.create(name)
	# 		end	
	# 	end

end