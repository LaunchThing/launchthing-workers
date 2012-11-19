require 'rubygems'
require 'sinatra'
require 'sidekiq'
require 'sidekiq/web'
require 'workers'

module LaunchThing
  class WorkerApp < Sinatra::Base

    get '/' do
      "LaunchThing workers"
    end

    get '/test' do
      TestWorker.perform_async
    end

    post '/crawl' do
      required = %w{crawl_url start_urls page_quota}
    	CrawlWorker.perform_async(valid?(args(required)))
    end

    #
    # Helpers
    #

    def args(keys)
      keys.inject({}) do |args, k|
        args.merge(k => params[k])
      end
    end

    def valid?(args)
      args.values.any? { |v| v.nil? } ? error : args
    end

  end
end