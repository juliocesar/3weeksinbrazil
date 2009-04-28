class AddSlugsToPosts < ActiveRecord::Migration
  def self.up
    add_column    :posts, :slug, :string
  end
  
  def self.down
    remote_column :posts, :slug
  end
end