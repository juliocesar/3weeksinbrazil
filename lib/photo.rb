class Photo
  def initialize(path)
    raise "#{path} does not exist" unless File.exists? path
    raise "#{path} is not an image" unless MIME::Types.of(path).first.media_type == 'image'
    @image = File.open(path)
  end
end