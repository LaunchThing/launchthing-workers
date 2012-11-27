require 'rubygems'
require 'sinatra'
require 'sidekiq'
require 'sidekiq/web'

require_relative 'workers'

module LaunchThing
  class WorkerApp < Sinatra::Base

    get '/' do
      "LaunchThing workers"
    end

    get '/test' do
      TestWorker.perform_async
    end

    post '/crawl' do
    	CrawlWorker.perform_async(params)
    end

    #
    # Helpers
    #

  end
end