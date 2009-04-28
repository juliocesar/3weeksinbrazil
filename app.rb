require 'rubygems'
require 'sinatra'

require File.join(File.dirname(__FILE__), 'config', 'boot')

get '/' do
  haml :home, :layout => false
end

get '/index' do
  @all_grouped = Post.all.group_by(&:location_from_time)
  @posts = Post.paginate :per_page => 8, :page => params[:page]
  @grouped = @posts.group_by(&:location_from_time)
  haml :index
end

helpers do
  
  def next_page
    return nil unless @posts.next_page
    haml_tag :a, :id => 'next', :href => "/index?page=#{@posts.next_page}" do
      haml_tag :img, :src => '/next.png'
    end
  end
  
  def previous_page
    return nil unless @posts.previous_page
    haml_tag :a, :id => 'previous', :href => "/index?page=#{@posts.previous_page}" do
      haml_tag :img, :src => '/previous.png'
    end
  end
  
end