desc "Grape API Routes"
task :routes do
  Yep::API.routes.each do |api|
    method = api.request_method.ljust(10)
    path   = api.path
    puts "     #{method} #{path}"
  end
end
