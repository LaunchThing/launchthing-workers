require 'tire'
require 'anemone'
require 'digest/md5'

module LaunchThing

  Tire.configure do
    url 'http://launchthing:esmoomoocow!@es-launchthing.cloudfoundry.com:80'
  end

  # Given a project and a URL:
  #  * fetches the content
  #  * indexes it in ElasticSearch
  #  * flags the URL as fetched with a date
  class PageWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :page

    def perform(project_id, site_id, page)
      page = Anemone::Page.from_hash(page)

      Tire.index('pages') do
        store(
          :id => Digest::MD5.hexdigest(page.url.to_s),
          :url => page.url.to_s,
          :project_id => project_id, 
          :site_id => site_id,
          :title => (page.doc.at_xpath("//title").text rescue nil),
          :type => 'legacy'
        )
      end
    end

  end
end