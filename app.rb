require 'rubygems'
require 'sinatra'

get '/' do
  haml :home, :layout => false
end