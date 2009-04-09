class Post < ActiveRecord::Base
  validates_presence_of :title, :body, :zone
  validate :timezone_exists
  
  private
  def timezone_exists
    begin
      TZInfo::Timezone.get zone      
    rescue TZInfo::InvalidTimezoneIdentifier
      errors.add 'zone', 'is not a valid timezone'
    end
  end
  
end