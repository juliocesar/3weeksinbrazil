class Post < ActiveRecord::Base
  has_many  :photos
  validates_presence_of :title, :body, :zone
  validate              :timezone_exists
  
  before_validation :set_slug
    
  def location_from_time
    CONFIG['itinerary'].each do |transit, dep_arr|
      if created_at > DateTime.strptime(dep_arr[0], "%d/%m/%Y %I:%M %p %Z") and
        created_at < DateTime.strptime(dep_arr[1], "%d/%m/%Y %I:%M %p %Z")
        return transit
      end
    end
    return 'In Brazil'
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