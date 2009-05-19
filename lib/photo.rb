class Photo < ActiveRecord::Base  
  belongs_to              :post
  validates_presence_of   :image
  has_attached_file :image,
    :path => "#{APP_ROOT}/public/photos/:id/:style/:basename.:extension",
    :url  => "/photos/:id/:style/:basename.:extension"
  default_scope :order => 'created_at ASC'
  
  def polaroid_path
    "/photos/#{id}/polaroid/#{pngize(image_file_name)}"
  end
  
  def polaroid!(output_path = nil)
    output_path ||= APP_ROOT/'public'/'photos'/id/'polaroid'/"#{File.basename(pngize(image.path))}"
    FileUtils.mkdir_p File.dirname(output_path) unless File.directory?(File.dirname(output_path))
    command = [
      'convert', image.path, '-thumbnail 130x130',
      '-bordercolor white', '-border 0.3', '-background transparent', '-background grey20',
      "-polaroid #{rand(5) * (rand(2).zero? ? -1 : 1)}", '-background white',
      output_path
    ].join ' '
    system command
    output_path
  end
  
  private
  def pngize(path)
    extension = File.extname(path)
    path.sub! /#{extension}$/, '.png'
  end
  
end
