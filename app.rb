require File.join(File.dirname(__FILE__), 'config', 'boot')

require 'sinatra'

get '/' do
  haml :home, :layout => false
end