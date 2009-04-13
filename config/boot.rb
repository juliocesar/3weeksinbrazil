require 'rubygems'
require 'activerecord'
require 'yaml'
require 'tzinfo'
require 'paperclip'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'mixins'
require 'config'

# App-wide config
begin
  config = YAML.load_file File.dirname(__FILE__)/'application.yml'
  # config.timify_itineraries!
  CONFIG = config
rescue Errno::ENOENT
  puts "application.yml not found. Bailing out."
  exit(1)
end

APP_ROOT = File.dirname(__FILE__)/'..'

ActiveRecord::Base.establish_connection(CONFIG['database'])
ActiveRecord::Base.logger = Logger.new(STDOUT)

require 'post'
require 'photo'