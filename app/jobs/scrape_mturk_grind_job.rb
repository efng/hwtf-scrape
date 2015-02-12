class ScrapeMturkGrindJob < ActiveJob::Base
  queue_as :mturk_grind
  ActiveJob::Base.queue_adapter = :delayed_job

  def perform(*args)
      old_page = args[0]
      mturk_grind = ScrapeMturkGrind.new old_page
      current_page = mturk_grind.scrape

      if Delayed::Job.where(queue: 'mturk_grind').count < 2
        current_page == old_page ? delay = 60.seconds : delay = 20.seconds

        self.class.set(wait: delay).perform_later(current_page)
      end
  end
end
