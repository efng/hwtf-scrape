class ScrapeRedditHWTFJob < ActiveJob::Base
  queue_as :reddit_hwtf
  ActiveJob::Base.queue_adapter = :delayed_job

  def perform(*args)
    "scraping reddit"
    ScrapeRedditHWTF.scrape
    if Delayed::Job.where(queue: 'reddit_hwtf').count < 2
      self.class.set(wait: 2.minutes).perform_later
    end
  end

end
