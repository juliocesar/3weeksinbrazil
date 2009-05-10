class Post < ActiveRecord::Base
  attr_accessor :skip_montage
  
  has_many  :photos, :dependent => :destroy
  
  validates_presence_of :title, :text, :zone
  validates_length_of   :title, :within => 1..85
  validate              :timezone_exists  
  
  before_validation :set_slug, :build_body
  after_save        :build_montage
  after_destroy     :delete_montage
    
  def location_from_time
    CONFIG['itinerary'].each do |transit, dep_arr|
      if created_at > DateTime.strptime(dep_arr[0], "%d/%m/%Y %I:%M %p %Z") and
        created_at < DateTime.strptime(dep_arr[1], "%d/%m/%Y %I:%M %p %Z")
        return transit
      end
    end
    'In Brazil'
  end
  
  def build_montage(force = false)
    return false if new_record? or skip_montage or photos.count.zero? or (montage_exists? and !force)
    FileUtils.mkdir_p APP_ROOT/'public'/'posts'/id
    if photos.count > 1
      montage! 3
    else
      polaroid! photos.first
    end
    montage_exists?
  end
  
  def montage_exists?
    File.exists? APP_ROOT/'public'/'posts'/id/'montage.png'
  end
  
  def montage_path
    "/posts/#{id}/montage.png"
  end
  
  def build_body
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
  
  private
  def timezone_exists
    begin
      TZInfo::Timezone.get zone      
    rescue TZInfo::InvalidTimezoneIdentifier
      errors.add 'zone', 'is not a valid timezone'
    end
  end
  
  def set_slug
    self.slug = title.to_url rescue nil
  end
  
  def montage!(total)
    _photos = photos.all :limit => total
    command = [
      "montage null:",
      _photos.map { |p| p.image.path },
      "-bordercolor white -thumbnail 110x110",
      "-background grey20 +polaroid -background Transparent -geometry '100x100-35+0'",
      "-tile 5x #{APP_ROOT}/public/posts/#{id}/montage.png"
    ].join ' '
   system command 
  end
  
  def polaroid!(photo)
    command = [
      'convert', photo.image.path, '-thumbnail 110x110',
      '-bordercolor white', '-background Transparent', '-background grey20',
      '+polaroid', '-background white',
      APP_ROOT/'public'/'posts'/id/'montage.png'
    ].join ' '
    puts "POLAROID: #{command}"
    system command
  end
  
end