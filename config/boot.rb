require 'rubygems'
require 'fileutils'
require 'yaml'
require 'redcloth'
require 'stringex'
require 'hpricot'
require 'will_paginate' 

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'mixins'

# App-wide config
begin
  CONFIG = YAML.load_file File.dirname(__FILE__)/'application.yml'
rescue Errno::ENOENT
  puts "application.yml not found. Bailing out."
  exit 1
end

APP_ROOT    = File.dirname(__FILE__)/'..'
POSTS_ROOT  = File.dirname(__FILE__)/'..'/'posts'

require 'post'
# require 'photo'
