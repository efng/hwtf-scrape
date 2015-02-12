# main class controler for HWTF
class HwtfController < ApplicationController

  def index
    @mturk_links = []
    @mturkgrind = "Failed"
    @reddithwtf = "Failed"

    if params[:hours_back]
      hours_back = params[:hours_back].to_i
      new_thread =  MTurkHits.where('created_at > ?',hours_back.hours.ago).first
      session[:id] = new_thread.id if new_thread
    end




    last_seen_id = session[:id]

    last_seen_id ||= MTurkHits.where('created_at > ?',12.hours.ago).first.id


    new_links = MTurkHits.where('id > ?',last_seen_id).limit(10)
    if new_links.last
      session[:id] = new_links.last.id
      assign_css_for_new_links new_links.reverse
    end


    old_links = MTurkHits.order(created_at: :desc).where('id <= ?',last_seen_id).limit(40)
    assign_css_for_old_links old_links

  end


  def assign_css_for_new_links(new_links)
    new_links.each do |link|
      link.link_flair_css_class = 'fresh'
      @mturk_links << link
    end
  end

  def assign_css_for_old_links(old_links)
    time_now = Time.now

    old_links.each do |link|
      age =  time_now - link.created_at

      age < 1600 ? css_class = 'stale' : css_class = 'old'
      link.link_flair_css_class = css_class

      # same as above line,but i think the above is more readable. Findout when I come back some day
      # link.link_flair_css_class = age < 1600 ? 'stale' : 'old'

      @mturk_links << link
    end
  end

end # class hwtf
