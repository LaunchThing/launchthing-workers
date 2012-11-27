require 'anemone'

module LaunchThing
  class CrawlWorker
    class PageQuotaReachedError < Exception; end

    include Sidekiq::Worker
    sidekiq_options :queue => :crawl

    include Mongoid::Document

    field :page_count, type: Integer
    field :page_quota, type: Integer, :default => 100
    field :start_pages, type: Array
    field :started_at, type: DateTime
    field :finished_at, type: DateTime

    field :project_id, type: BSON::ObjectId
    field :site_id, type: BSON::ObjectId

    def perform(attributes)
      self.attributes = attributes
      self.save if new_record?
      self.started_at = Time.now
      crawl
    rescue PageQuotaReachedError
      # TODO: something
    ensure
      self.finished_at = Time.now
      save
    end

    private

    def crawl
      self.page_count = 0
      Anemone.crawl(start_pages) do |anemone|
        anemone.on_every_page do |page|
          store(page)
        end
      end
      self
    end

    def store(page)
      raise PageQuotaReachedError if self.page_count >= self.page_quota
      self.page_count += 1
      PageWorker.perform_async(project_id, site_id, page.to_hash)
    end

  end
end
