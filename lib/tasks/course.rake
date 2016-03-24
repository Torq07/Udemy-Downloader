desc "Uploading course"
task :upload => :environment do
	exec("udemy-dl -u torq07@gmail.com -p wry135qa --lecture-start 1 --lecture-end 3  #{ENV["course_url"]}")
	course.uploaded
end