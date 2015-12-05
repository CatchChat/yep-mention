$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'
require 'dotenv'
Dotenv.load

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV']
require 'aes256'
require 'goliath'

Goliath.env = ENV['RACK_ENV']

Dir[File.expand_path('../../config/initializers/*.rb', __FILE__)].each do |f|
  require f
end

Dir[File.expand_path('../../api/**/*.rb', __FILE__)].each do |f|
  require f
end

require 'api'
require 'yep_app'
