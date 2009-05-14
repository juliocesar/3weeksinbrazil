class Photo < ActiveRecord::Base  
  belongs_to              :post
  validates_presence_of   :image
  has_attached_file :image,
    :path => "#{APP_ROOT}/public/photos/:id/:style/:basename.:extension",
    :url  => "/photos/:id/:style/:basename.:extension"
  default_scope :order => 'created_at DESC'
  
  def polaroid_path
    "/photos/#{id}/polaroid/#{pngize(image_file_name)}"
  end
  
  private
  def pngize(path)
    extension = File.extname(path)
    path.sub! /#{extension}$/, '.png'
  end
  
end