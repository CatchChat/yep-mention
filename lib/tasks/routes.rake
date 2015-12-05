desc "Grape API Routes"
task :routes do
  Yep::API.routes.each do |api|
    method = api.route_method.ljust(10)
    path   = api.route_path
    puts "     #{method} #{path}"
  end
end
