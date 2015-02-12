class ScrapeRedditHWTF
    def self.scrape
    
    retry_count = 0
    reddit_links = []


    begin
      client = RedditKit::Client.new
      client.user_agent = 'EFNG HWFT/0.2.1'
      # TODO: refactor so there are not 2 assignment to same var
      reddit_links = client.links('HITsWorthTurkingFor', { category: :new, limit: 50 })
      reddit_links = reddit_links.reject { |link| link.link_flair_css_class }
    rescue RedditKit::RequestError
      retry_count += 1
      if retry_count < 3 # should pass along an error, for now just returns
        sleep 5
        retry
      end
    end

    reddit_links.each do |link|
      extraced_link = extract_hwtf_link(link.selftext)

      mturk_link = MTurkHits.find_by(working_url: extraced_link)

      if extraced_link and !mturk_link
        mturk_link = MTurkHits.new

        mturk_link.working_url = extract_hwtf_link(link.selftext)
        next unless mturk_link.working_url

        mturk_link.selftext_html = link.selftext_html
        mturk_link.selftext = link.selftext
        mturk_link.author = link.author
        mturk_link.url = link.url
        mturk_link.title = link.title

        mturk_link.save
      end

    end

  end


  def self.extract_hwtf_link(selftext)
    mturk_valid_url = %r{\Ahttps?://(w{3}.)?mturk.com/[\S]+}
    adfly_valid_url = %r{\Ahttps?://(w{3}.)?adf.ly/[\S]+}

    # I beleive redditkit changes the '&' to '&amp;'
    selftext.gsub!(/&amp;/, '&')

    # there are often malformed/confusing URLs in the reddit posts. This removes
    # brackes so they won't be in URLs. Then finds the first URL we like
    selftext.gsub!(/[\[\]\(\)]/, ' ')

    URI.extract(selftext).reduce(nil) do |memo, item|
      memo = item.slice(mturk_valid_url)
      memo ||= item.slice(adfly_valid_url)
      # FIXME: have only one,smooth line
      if memo
        break memo
      end
    end
  end


end
