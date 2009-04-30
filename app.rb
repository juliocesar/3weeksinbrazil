require 'rubygems'
require 'sinatra'

require File.join(File.dirname(__FILE__), 'config', 'boot')

get '/' do
  haml :home, :layout => false
end

get '/index' do
  @all_grouped = Post.all.group_by(&:location_from_time)
  @posts = Post.paginate :per_page => 18, :page => params[:page]
  @grouped = @posts.group_by(&:location_from_time)
  haml :index
end

get '/:slug' do
  @post = Post.find_by_slug! params[:slug]
  case @post.photos.count
  when 1
    haml :post_1pic
  when 2
    haml :post_2pics
  when 3
    haml :post_picscollection
  else
    haml :post_nopics
  end
end

helpers do
  
  def next_page
    return unless @posts.next_page
    haml_tag :a, :id => 'next', :href => "/index?page=#{@posts.next_page}" do
      haml_tag :img, :src => '/next.png'
    end
  end
  
  def previous_page
    return unless @posts.previous_page
    haml_tag :a, :id => 'previous', :href => "/index?page=#{@posts.previous_page}" do
      haml_tag :img, :src => '/previous.png'
    end
  end
  
  def three_weeks_logo
    haml_tag :a, :href => '/' do
      haml_tag :img, :id => 'weeks-small', :src => '/3_weeks_small.png', :alt => '3 weeks in Brazil'
    end
  end
end