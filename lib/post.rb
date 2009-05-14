class Post
  attr_accessor :text, :body, :dirname
  
  def self.all
    Dir.chdir POSTS_ROOT
    valids = []
    Dir['*'].each do |dir|
      valids << dir if File.exists?(dir/'text') and File.exists?(dir/'body')
    end
    valids
  end
  
  def self.open(dirname)
    all.include?(dirname) ? new(dirname) : nil
  end
  
  def initialize(dirname)
  end
  
end