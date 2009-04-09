require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require 'spec'

require 'factory_girl'
require 'faker'

Factory.define :post do |post|
  post.title  { Faker::Lorem.paragraph }  
  post.body   { Faker::Lorem.paragraph }
  post.zone   'Australia/Sydney'
end