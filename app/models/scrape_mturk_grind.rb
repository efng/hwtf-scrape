class ScrapeMturkGrind
  # require 'set'

  # module MturkGrind
  MTURK_GRIND_REGEX = %r{\Ahttps?://(w{3}.)?mturk.com/mturk/preview[\S]+}
  # attr_reader :new_links
  attr_reader :current_page,:links


  def initialize(current_page = "")
    # @new_links = []
    @current_page = current_page || ""
    agent_setup


  end

  def scrape(current_page = nil)

    @current_page = current_page if current_page

    get_links_from_mturk_web_page
  end

  def get_links_from_mturk_web_page

    
    retry_count = 0
    begin
      find_current_thread 
      set_current_page 
      harvest_from_mturk_grind 
    rescue Errno::ETIMEDOUT, SocketError
      retry_count += 1
      if retry_count < 3
        # TODO: pass along an @error , for now just returns
        sleep 5
        retry
      end
    end
    
    #filter_harvested_mturk_grind_links
    @current_page  
  end



  def agent_setup
    @agent = Mechanize.new()
    @agent.user_agent = 'Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.1; SLCC1; .NET CLR 1.1.4322)'
  end
  
  def find_current_thread

    # the thread section on mturkgrind
    @agent.get('http://www.mturkgrind.com/forums/awesome-hits.4')

    # This is the CSS selector for the current days thread
    @agent.click @agent.page.at('.xbStickyBar+.discussionListItems .title a')
  end
  
  def set_current_page
    #Has a newday started since list vist
    current_thread = @agent.page.uri.to_s
    
    @current_page = current_thread unless @current_page.include? current_thread
      

  end


  def harvest_from_mturk_grind


    @agent.get @current_page

    @links = @agent.page.links_with(href: MTURK_GRIND_REGEX)
    
    filter_harvested_mturk_grind_links

    next_page = @agent.page.link_with(text: 'Next >')
    if next_page
      @agent.click next_page
      @current_page = @agent.page.uri.to_s
    end
    # TODO: break if collecting the links is taking to much time

  end

  def filter_harvested_mturk_grind_links
    @links.map! do |link|
      link.href.gsub!(/preview\?/, 'previewandaccept?')
      link
    end
      
    @links.each do |link|
      mturk_link = MTurkHits.where("created_at > ? and working_url = ? ", 1.day.ago, link.href )

      # mturk_link = MTurkHits.find_by(working_url: link.href)
      if mturk_link.count == 0
        mturk_link = MTurkHits.new

        mturk_link.working_url = link.href

        mturk_link.selftext_html = 'TBD2'
        mturk_link.selftext = @current_page
        mturk_link.author = 'TBD'
        mturk_link.url = @current_page
        mturk_link.title = link.text

        mturk_link.save
        # @new_links << mturk_link
      end

    end
  end

end 
