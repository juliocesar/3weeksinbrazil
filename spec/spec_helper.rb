require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require 'spec'

require 'factory_girl'
require 'faker'

def upload_photo
  File.open File.dirname(__FILE__)/'fixtures'/'lacador.jpg'
end

Factory.define :post do |post|
  post.title  { Faker::Lorem.paragraph }  
  post.body   { Faker::Lorem.paragraph }
  post.zone   'Australia/Sydney'
end

Factory.define :photo do |photo|
  photo.association :post
  photo.image       { upload_photo }
end