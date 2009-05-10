class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string    :title, :limit => 85,   :null => false
      t.string    :zone,                  :null => false
      t.text      :body, :text
      t.datetime  :created_at
    end
  end
  
  def self.down
    drop_table :posts
  end
end