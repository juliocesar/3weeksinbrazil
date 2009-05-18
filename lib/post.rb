class Post < ActiveRecord::Base
  attr_accessor :skip_montage
  
  has_many  :photos, :dependent => :destroy
  
  validates_presence_of :title, :text
  validates_length_of   :title, :within => 1..85
  
  before_validation :set_slug, :build_body!
  after_save        :build_montage!
  after_destroy     :delete_montage
    
  def location
    CONFIG['itinerary'].each do |transit, dep_arr|
      if created_at > DateTime.strptime(dep_arr[0], "%d/%m/%Y %I:%M %p %Z") and
        created_at < DateTime.strptime(dep_arr[1], "%d/%m/%Y %I:%M %p %Z")
        return transit
      end
    end
    'In Brazil'
  end
  
  def build_montage!
    return false if new_record? or skip_montage or photos.count.zero?
    FileUtils.mkdir_p APP_ROOT/'public'/'posts'/id
    if photos.count > 1
      polaroids = photos.all.inject([]) do |result, photo|
        result << polaroid!(photo)
      end
      stack_polaroids! polaroids[0..2]
    else
      polaroid! photos.first
      polaroid! photos.first, APP_ROOT/'public'/'posts'/id/'montage.png'
    end
    montage_exists?
  end
  
  def montage_exists?
    File.exists? APP_ROOT/'public'/'posts'/id/'montage.png'
  end
  
  def montage_path
    "/posts/#{id}/montage.png"
  end
    
  def build_body!
    return unless text
    if montage_exists?
      doc = Hpricot(RedCloth.new(text).to_html)
      p = (doc/'p').first
      p.inner_html = [
        "<a href=\"/#{slug}/photos\">",
          "<img id=\"pic\" src=\"#{montage_path}\" />",
        "</a>",
        p.inner_html
      ].join
      self.body = doc.to_s
    else
      self.body = RedCloth.new(text).to_html
    end
  end
  
  def delete_montage
    return false unless montage_exists?
    FileUtils.rm_rf APP_ROOT/'public'/'posts'/id
  end
  
  def self.create_or_update_from_directory(path)
    raise ArgumentError, "#{path} must be a valid post directory" unless valid_post_dir?(path)
    text_file = File.open(path/'text')
    title = text_file.readlines.first.chomp
    text_file.rewind and text_file.seek(title.length)
    text = text_file.read
    if post = Post.find_by_slug(title.to_url)
      result = post.update_attributes! :title => title, :text => text
    else
      post = Post.create :title => title, :text => text
    end
    if File.directory?(path/'photos')
      Dir[path/'photos'/'*.jpg'].each do |photo|
        if Photo.find_by_image_file_name File.basename(photo)
          puts "PHOTO ALREADY EXISTS"
          next
        else
          Photo.create :post => post, :image => File.open(photo)
        end
      end
    end
    post
  end
  
  def self.valid_post_dir?(path)
    File.directory?(path) and File.exist?(path/'text')
  end
  
  private
  def set_slug
    self.slug = title.to_url rescue nil
  end
    
  def polaroid!(photo, output_path = nil)
    output_path ||= APP_ROOT/'public'/'photos'/photo.id/'polaroid'/"#{File.basename(pngize(photo.image.path))}"
    FileUtils.mkdir_p File.dirname(output_path) unless File.directory?(File.dirname(output_path))
    command = [
      'convert', photo.image.path, '-thumbnail 130x130',
      '-bordercolor white', '-border 0.3', '-background transparent', '-background grey20',
      "-polaroid #{rand(5) * (rand(2).zero? ? -1 : 1)}", '-background white',
      output_path
    ].join ' '
    system command
    output_path
  end
  
  def pngize(path)
    extension = File.extname(path)
    path.sub! /#{extension}$/, '.png'
  end
  
  def stack_polaroids!(images_paths)
    first, geometry = images_paths.shift, 0
    command = [
      'convert', '-size 200x200', 'xc:transparent', 
      first, '-geometry +0+0',
      images_paths.map { |path| ['-composite', path, "-geometry +#{geometry += 10}+0"] },
      '-composite', '-trim',
      APP_ROOT/'public'/'posts'/id/'montage.png'
    ].join ' '
    system command
  end
    
end
