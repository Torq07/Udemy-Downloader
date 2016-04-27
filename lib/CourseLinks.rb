require 'UdemySession'
require 'open-uri'

class CourseLinks
	def initialize(link_file,title_file)
		@links=File.open(link_file,'r+').readlines
		@names=File.open(title_file,'r+').readlines
		@listing={}
	end	

	attr_accessor :links, :names, :listing

	def get_data
		@names.each do |title|
			if title[/^\d{2}\s/]
				@listing[title.to_sym]={}
			end
			if title[(/^\d{3}\s/)]		
				@listing[@listing.keys.last][title.to_sym]=@links[Regexp.last_match(0).to_i-1]
			end	
		end
	end

	def download_pages(username,pass)
		@listing.each do |chapter,v|
			v.each do |lecture,link|
				p link
				if link.include?('/view/?data=')
					name=lecture.to_s.strip.gsub(' ','_')
					open("#{Rails.root}/#{name}.html", "wb") {|f| f.write(udemy.get(link).body)}
					@listing[chapter][lecture]="#{Rails.root}/#{name}.html"
				end	
			end	
		end
	end
	def get_id(course_link,username,pass)
		udemy=UdemySession.new
		udemy.login(username,pass)
		id=udemy.get_course_id(course_link)
		udemy.get_data_links(id)
	end
end
	