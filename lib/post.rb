class Post
  attr_accessor :text, :body, :dirname, :dir, :name
  
  def self.all
    valids = []
    Dir.chdir POSTS_ROOT do
      Dir['*'].each do |dir|
        valids << Post.open(dir) if File.exists?(dir/'text') and File.exists?(dir/'body.textile')
      end
    end
    valids
  end
  
  def self.open(dirname)
    new(POSTS_ROOT/dirname)
  end
  
  def initialize(dirname)
    self.text = File.read dirname/'text'
    @dir = File.expand_path dirname
    @name = File.basename @dir
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
    puts "COMMAND: #{command}"
    system command
  end
  
end