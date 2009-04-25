require 'rubygems'
require 'activerecord'
require 'yaml'
require 'tzinfo'
require 'paperclip'
require 'will_paginate'

WillPaginate.enable_activerecord

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'mixins'

# App-wide config
begin
  CONFIG = YAML.load_file File.dirname(__FILE__)/'application.yml'
rescue Errno::ENOENT
  puts "application.yml not found. Bailing out."
  exit(1)
end

APP_ROOT = File.dirname(__FILE__)/'..'

ActiveRecord::Base.establish_connection(CONFIG['database'])
ActiveRecord::Base.logger = Logger.new(STDOUT)

require 'post'
require 'photo'
