class Photo
  def initialize(path)
    raise "#{path} does not exist" unless File.exists? path
    raise "#{path} is not an image" unless MIME::Types.of(path).first.media_type == 'image'
    @image = File.open(path)
  end
  
  def post(basename = false)
    basename ? File.basename(File.dirname(__FILE__)/'..') : File.dirname(__FILE__)/'..'
  end
  
  def polaroid!(output_path = APP_ROOT/'public'/post.dir/)
    
    
  end
  
end