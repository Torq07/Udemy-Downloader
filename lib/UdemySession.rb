require 'mechanize'
require 'json'

class UdemySession
    attr_accessor :session

    
    def initialize
      @session=Mechanize.new
      @session.request_headers={'User-Agent'=> 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:39.0) Gecko/20100101 Firefox/39.0',
                               'X-Requested-With'=> 'XMLHttpRequest',
                               'Host'=> 'www.udemy.com',
                               'Referer'=> 'https://www.udemy.com/join/login-popup'}
    end

    def set_auth_headers(access_token, client_id)
        """Setting up authentication headers."""
        self.session.request_headers['X-Udemy-Bearer-Token'] = access_token
        self.session.request_headers['X-Udemy-Client-Id'] = client_id
        self.session.request_headers['Authorization'] = "Bearer " + access_token
        self.session.request_headers['X-Udemy-Authorization'] = "Bearer " + access_token
    end
        	
    def get(url)
        """Retreiving content of a given url."""
        return self.session.get(url)
    end
        
    def post(url, data)
        """HTTP post given data with requests object."""
		uri = URI.parse(url)
        return self.session.post(url,data)        
    end

    def get_csrf_token
        resp = self.get('https://www.udemy.com/join/login-popup')
        resp.body[/name='csrfmiddlewaretoken'\s+value='(.*)'/]
        Regexp.last_match(1)
    end        

    def login(username, password)
        log_url = "https://www.udemy.com/join/login-popup/?displayType=ajax&display_type=popup&showSkipButton=1&returnUrlAfterLogin=https%3A%2F%2Fwww.udemy.com%2F&next=https%3A%2F%2Fwww.udemy.com%2F&locale=en_US"
        csrf_token = get_csrf_token
        payload = {'isSubmitted': 1, 'email': username, 'password': password,
                   'displayType': 'ajax', 'csrfmiddlewaretoken'=>csrf_token}
        resp = self.post(log_url, payload)
        access_token = self.session.cookies.select{|e| e.name=='access_token'}.last.value
        client_id = self.session.cookies.select{|e| e.name=='client_id'}.last.value
        if !access_token
            print("Error: Couldn't fetch token !")
        end    
        self.set_auth_headers(access_token, client_id)
    end      

    def get_course_id(course_link)
        if course_link.include?('udemy.com/draft/')
            course_id = course_link.split('/')[-1]
           return course_id
        end
        response = self.session.get(course_link).body
        matches=/data-course-id="(\d+)"/i.match(response)   
        if matches
            course_id = Regexp.last_match(0)
        else
            matches = /property="og:image"\s+content="([^"]+)"/i.match(response)
            course_id = Regexp.last_match(1).split('/', -1)[-1].split('_', -1)[0] 
        end
        course_id    
    end

    def get_data_links(course_id)
        course_url = 'https://www.udemy.com/api-2.0/courses/#{course_id}/subscriber-curriculum-items?fields[asset]=@default,length&fields[chapter]=@default,object_index&fields[lecture]=@default,asset,content_summary,num_discussions,num_external_link_assets,num_notes,num_source_code_assets,object_index,url&fields[quiz]=@default,content_summary,object_index,url&page_size=9999'
        p course_data = self.session.get(course_url)
    end    
end
