require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require 'spec'

require 'factory_girl'
require 'faker'

def upload_photo
  File.open File.dirname(__FILE__)/'fixtures'/'lacador.jpg'
end

def create_post
  post = Factory.build :post
  post.created_at = Time.parse('Wed May 20 11:00:00 UTC 2009') + rand(21).days
  post.save!
  post
end

Factory.define :post do |post|
  post.title        { Faker::Lorem.paragraph[0..84] }
  post.text         { Faker::Lorem.paragraph } 
  post.zone         'Australia/Sydney'
end

Factory.define :photo do |photo|
  photo.association :post
  photo.image       { upload_photo }
end