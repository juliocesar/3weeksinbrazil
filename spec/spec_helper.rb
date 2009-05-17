require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require 'spec'
require 'faker'

FileUtils.mkdir '/tmp/testdata' unless File.directory? '/tmp/testdata'

POSTS_ROOT = '/tmp/testdata'

def upload_photo
  File.open File.dirname(__FILE__)/'fixtures'/'lacador.jpg'
end

def create_post(name)
  FileUtils.mkdir_p POSTS_ROOT/name/'photos'
  FileUtils.touch   POSTS_ROOT/name/'text'
  FileUtils.touch   POSTS_ROOT/name/'body.textile'
  FileUtils.cp      File.dirname(__FILE__)/'fixtures'/'lacador.jpg', POSTS_ROOT/name/'photos/'
  FileUtils.cp      File.dirname(__FILE__)/'fixtures'/'lacador.jpg', POSTS_ROOT/name/'photos/lacador2.jpg'
  `echo #{Faker::Lorem.paragraph} >> #{POSTS_ROOT/name/'text'}`  
  return Post.open(name)
end