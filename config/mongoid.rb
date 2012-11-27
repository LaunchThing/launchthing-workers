require 'mongo'
require 'mongoid'

Mongoid.load!(File.join(File.dirname(__FILE__), 'mongoid.yml'))

# Check we can ping here...
Mongoid.master.command(ping: 1)