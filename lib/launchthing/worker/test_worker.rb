module LaunchThing
  class TestWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :crawl

    def perform
      # NOOP - but perhaps something later for acceptance testing.
    end

  end
end