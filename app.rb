require 'rubygems'
require 'sinatra'

require File.join(File.dirname(__FILE__), 'config', 'boot')

get '/'       do haml :home, :layout => false end
get '/intro'  do haml :intro end

get '/index' do
  @all_grouped = Post.all.group_by(&:location_from_time)
  @posts = Post.paginate :per_page => 18, :page => params[:page]
  @grouped = @posts.group_by(&:location_from_time)
  haml :index
end

get '/:slug' do
  @post = Post.find_by_slug! params[:slug]
  haml :post
end

get '/:slug/photos' do
  @post = Post.find_by_slug! params[:slug]
  @photos = @post.photos.paginate :per_page => 11, :page => params[:page]
  haml :photos
end

helpers do  
  def next_page(collection, url)
    return unless collection.next_page
    haml_tag :a, :id => 'next', :href => url do
      haml_tag :img, :src => '/next.png'
    end
  end
  
  def previous_page(collection, url)
    return unless collection.previous_page
    haml_tag :a, :id => 'previous', :href => url do
      haml_tag :img, :src => '/previous.png'
    end
  end
  
  def three_weeks_logo
    haml_tag :a, :href => '/' do
      haml_tag :img, :id => 'weeks-small', :src => '/3_weeks_small.png', :alt => '3 weeks in Brazil'
    end
  end
end