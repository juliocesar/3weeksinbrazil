require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require 'spec'

require 'factory_girl'
require 'faker'

POSTS_ROOT = '/tmp/posts'
FileUtils.mkdir_p POSTS_ROOT

def upload_photo
  File.open File.dirname(__FILE__)/'fixtures'/'lacador.jpg'
end

def create_post_with_date(date = Time.parse('Wed May 20 11:00:00 UTC 2009') + rand(21).days)
  post = Factory.build :post
  post.created_at = 
  post.save!
  post
end

def create_post_directory(dirname, path = '/tmp/posts')
  FileUtils.mkdir_p path/dirname/'photos'
  `echo #{Faker::Lorem.name} >> #{path/dirname/'text'}`       # title
  `echo #{Faker::Lorem.paragraph} >> #{path/dirname/'text'}`  # body
  FileUtils.cp File.dirname(__FILE__)/'fixtures'/'lacador.jpg', path/dirname/'photos/'
  dirname
end

Factory.define :post do |post|
  post.title        { Faker::Lorem.paragraph[0..84] }
  post.text         { Faker::Lorem.paragraph } 
end

Factory.define :photo do |photo|
  photo.association :post
  photo.image       { upload_photo }
end
