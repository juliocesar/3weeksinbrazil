class Post < ActiveRecord::Base
  attr_accessor :skip_montage
  has_many  :photos
  validates_presence_of :title, :body, :zone
  validate              :timezone_exists
  
  before_validation :set_slug
  after_save        :build_montage
    
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
    FileUtils.mkdir_p "#{APP_ROOT}/public/posts/#{id}"
    photo = photos.all :limit => 3, :order => 'created_at DESC'
    command = [
      "montage null:",
      photos.map { |p| p.image.path },
      "-bordercolor snow -quality 5",
      "-background grey20 +polaroid -background Transparent -geometry '100x100>-55+0<'",
      "-tile 5x #{APP_ROOT}/public/posts/#{id}/montage.png"
    ].join ' '
    system command
    montage_exists?
  end
  
  def montage_exists?
    File.exists?("#{APP_ROOT}/public/posts/#{id}/montage.png")
  end
  
  def montage_path
    "/posts/#{id}/montage.png"
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
  
end