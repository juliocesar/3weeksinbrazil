require 'rubygems'
require 'sinatra'
require 'yaml'
require 'activerecord'

# App-wide config
begin
  CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'application.yml'))
rescue Errno::ENOENT
  puts "application.yml not found. Bailing out."
  exit(1)
end

# Database
ActiveRecord::Base.establish_connection(CONFIG['database'])

get '/' do
  haml :home, :layout => false
end