class Photo
  attr_accessor :photo
  def initialize(path)
    raise "#{path} does not exist" unless File.exists? path
    raise "#{path} is not an image" unless MIME::Types.of(path).first.media_type == 'image'
    @image = File.open(path)
  end
  
  def post(basename = false)
    Post.open File.basename(File.expand_path(File.dirname(@image.path)/'..'/'..'))
  end
  
  def path(polaroid = false)
    polaroid ? post.dir/'polaroids'/"#{File.basename(pngize(@image.path))}" : @image.path
  end
  
  def polaroid!(output_path = path(:polaroid))
    FileUtils.mkdir_p File.dirname(output_path) unless File.directory?(File.dirname(output_path))
    command = [
      'convert', @image.path, '-thumbnail 130x130',
      '-bordercolor white', '-border 0.3', '-background transparent', '-background grey20',
      "-polaroid #{rand(5) * (rand(2).zero? ? -1 : 1)}", '-background white',
      output_path
    ].join ' '
    system command
    output_path
  end
  
  def polaroid_exists?
    File.exists? path(:polaroid)
  end
  
  private
  def pngize(path)
    extension = File.extname(path)
    path.sub! /#{extension}$/, '.png'
  end
  
end