require 'rubygems'
require 'sinatra'

require File.join(File.dirname(__FILE__), 'config', 'boot')

get '/' do
  haml :home, :layout => false
end

get '/index' do  
  @posts = Post.paginate :per_page => 9, :page => params[:page]
  @grouped = @posts.group_by(&:location_from_time)
  haml :index
end