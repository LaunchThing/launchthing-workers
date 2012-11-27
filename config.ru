require './app'
require 'sidekiq'

use Rack::Auth::Basic, "LaunchThing workers" do |username, password|
  [username, password] == [ENV['USERNAME'], ENV['PASSWORD']]
end

run Rack::URLMap.new \
  "/" => LaunchThing::WorkerApp.new,
  "/sidekiq" => Sidekiq::Web.new
