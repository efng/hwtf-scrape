class CreateMTurkHits < ActiveRecord::Migration
  def change
    create_table :m_turk_hits do |t|

      #this block is from redditkit
      t.text   :selftext_html
      t.string :selftext
      t.string :author
      t.string :link_flair_css_class
      t.string :url
      t.string :title
      t.datetime :created_utc_reddit    #created_utc in redditkit


      #this block is from new
      #TODO
      # :working_url
      # :final_url
      # :visted

      t.timestamps
    end
  end
end
