require 'rubygems'
require 'sinatra'

require File.join(File.dirname(__FILE__), 'config', 'boot')

get '/' do
  haml :home, :layout => false
end

get '/index' do  
  @posts = Post.all
  haml :index
end