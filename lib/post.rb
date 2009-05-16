class Post
  attr_accessor :text, :body, :dirname
  
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
    all.include?(dirname) ? new(POSTS_ROOT/dirname) : nil
  end
  
  def initialize(dirname)
    self.text = File.read dirname/'text'
    @dir = dirname
  end
    
  # def delete!
  #   FileUtils.rm_rf @dir
  # end
  
  def exists?
    File.directory? @dir
  end
  
  def photos
    @photos = []
    Dir[@dir/'photos'/'*.jpg', @dir/'photos'/'*.png', @dir/'photos'/'*.gif'].each do |image|
      @photos << Photo.new(image)
    end
    @photos
  end
  
  
  
end