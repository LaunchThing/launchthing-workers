require_relative 'config/mongoid'
require_relative 'config/sidekiq'

Dir[File.join(File.dirname(__FILE__), 'lib/launchthing/worker/*.rb')].each do |worker|
  require worker
end

