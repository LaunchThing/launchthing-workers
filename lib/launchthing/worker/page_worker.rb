require 'tire'

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

    def perform(project, url)
    end

  end
end