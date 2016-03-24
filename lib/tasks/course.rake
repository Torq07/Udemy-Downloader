desc "Uploading course"
task :upload => :environment do
	exec("udemy-dl -u torq07@gmail.com -p wry135qa --lecture-start 1 --lecture-end 1  #{ENV["COURSE_URL"]} -o ./COURSER/")
	# course.uploaded
end