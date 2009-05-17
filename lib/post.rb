class Post
  attr_accessor :text, :body, :dirname, :dir
  
  def self.all
    valids = []
    Dir.chdir POSTS_ROOT do
      # Dir['*'].inject going weird for some reason...
      Dir['*'].each do |dir|
        valids << dir if File.exists?(dir/'text') and File.exists?(dir/'body')
      end
    end
    valids
  end
  
  def self.open(dirname)
    all.include?(File.basename(dirname)) ? new(POSTS_ROOT/dirname) : nil
  end
  
  def initialize(dirname)
    self.text = File.read dirname/'text'
    @dir = File.expand_path dirname
  end
    
  def exists?
    File.directory? dir
  end
  
  def photos
    @photos = []
    Dir[dir/'photos'/'*.jpg', dir/'photos'/'*.png', dir/'photos'/'*.gif'].each do |image|
      @photos << Photo.new(image)
    end
    @photos
  end
  
  def montage_path
    dir/'montage.png'
  end
  
  def stack_polaroids!(number_of_photos = 3)
    _photos = photos[0..number_of_photos]
    _photos.each do |photo|
      photo.polaroid! unless photo.polaroid_exists?
    end
    first, geometry = _photos.shift, 0
    command = [
      'convert', '-size 200x200', 'xc:transparent', 
      first.path(:polaroid), '-geometry +0+0',
      _photos.map { |photo| ['-composite', photo.path(:polaroid), "-geometry +#{geometry += 10}+0"] },
      '-composite', '-trim',
      montage_path
    ].join ' '
    system command
  end
  
end