require 'anemone'

module LaunchThing
  class CrawlWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :crawl

    def perform(options)
    end

  end
end