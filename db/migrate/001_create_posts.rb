class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |table|
      table.with_options(:null => false) do |t|
        t.string    :title, :limit => 90
        t.string    :zone
        t.text      :body
        t.datetime  :created_at
      end
    end
  end
  
  def self.down
    drop_table :posts
  end
end