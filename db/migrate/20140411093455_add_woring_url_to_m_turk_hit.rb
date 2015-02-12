class AddWoringUrlToMTurkHit < ActiveRecord::Migration
  def change
    add_column :m_turk_hits, :working_url, :string
  end
end
