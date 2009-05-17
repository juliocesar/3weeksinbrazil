require 'rubygems'
require 'fileutils'
require 'yaml'
require 'redcloth'
require 'stringex'
require 'hpricot'
require 'will_paginate' 
require 'mime/types'
require 'grit'
include Grit

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'mixins'

# App-wide config
begin
  CONFIG = YAML.load_file File.dirname(__FILE__)/'application.yml'
rescue Errno::ENOENT
  STDERR.puts "application.yml not found. Bailing out."
  exit 1
end

APP_ROOT    = File.dirname(__FILE__)/'..'
POSTS_ROOT  = File.dirname(__FILE__)/'..'/'posts'
begin
  REPO = Repo.new POSTS_ROOT
rescue
  STDERR.puts "POSTS_ROOT (#{POSTS_ROOT}) not found, or not a git repository"
end    

require 'post'
require 'photo'
