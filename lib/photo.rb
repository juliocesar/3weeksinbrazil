class Photo < ActiveRecord::Base  
  belongs_to              :post
  validates_presence_of   :image
  has_attached_file :image,
    :path => "#{APP_ROOT}/public/photos/:id/:style/:basename.:extension",
    :url  => "/photos/:id/:style/:basename.:extension"
end