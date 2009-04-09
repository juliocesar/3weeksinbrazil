class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string    :caption
      t.string    :image_file_name, :image_content_type,  :null => false
      t.integer   :image_file_size,                       :null => false
      t.datetime  :image_updated_at
    end
  end
  
  def self.down
    drop_table :posts
  end
end