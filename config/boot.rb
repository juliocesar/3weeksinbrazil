require 'rubygems'
require 'activerecord'
require 'yaml'
require 'tzinfo'
gem     'thoughtbot-paperclip'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'mixins'

# App-wide config
begin
  CONFIG = YAML.load_file File.dirname(__FILE__)/'application.yml'
rescue Errno::ENOENT
  puts "application.yml not found. Bailing out."
  exit(1)
end

ActiveRecord::Base.establish_connection(CONFIG['database'])

require 'post'


