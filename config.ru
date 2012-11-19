require './app'
require 'sidekiq'

use Rack::Auth::Basic, "LaunchThing workers" do |username, password|
  [username, password] == [ENV['USERNAME'], ENV['PASSWORD']]
end

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

run Rack::URLMap.new \
  "/" => LaunchThing::WorkerApp.new,
  "/sidekiq" => Sidekiq::Web.new
