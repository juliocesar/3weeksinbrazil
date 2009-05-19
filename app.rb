require 'rubygems'
require 'sinatra'

require File.join(File.dirname(__FILE__), 'config', 'boot')

get '/'       do haml :home, :layout => false end
get '/intro'  do haml :intro end

get '/posts.xml' do 
  @posts = Post.all :order => 'created_at DESC'
  # to my dismay... but readers just seem to take it better
  content_type 'text/xml'
  builder :feed
end

get '/index' do
  @all_grouped = Post.all.group_by(&:location)
  @posts = Post.paginate :per_page => 18, :page => params[:page]
  @grouped = @posts.group_by(&:location)
  haml :index
end

get '/pics' do
  @posts = Post.paginate :joins => [:photos], :group => 'posts.id', :per_page => 10, :page => params[:page]
  haml :pics
end

get '/:slug' do
  begin
    @post = Post.find_by_slug! params[:slug]
    haml :post
  rescue ActiveRecord::RecordNotFound
    not_found
  end
end

get '/:slug/photos' do
  begin
    @post = Post.find_by_slug! params[:slug]
    @photos = @post.photos.paginate :per_page => 11, :page => params[:page]
    haml :photos
  rescue ActiveRecord::RecordNotFound
    not_found
  end
end

not_found do
  content_type 'text/plain'
  "No art for the wicked. Try going to http://3weeksinbrazil.com"
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
