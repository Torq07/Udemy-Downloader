json.array!(@courses) do |course|
  json.extract! course, :id, :name, :url
  json.url course_url(course, format: :json)
end
