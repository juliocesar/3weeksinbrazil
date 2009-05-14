require File.join(File.dirname(__FILE__), '..', 'config', 'boot')
require 'spec'
require 'faker'

POSTS_ROOT = '/tmp/testdata'

def upload_photo
  File.open File.dirname(__FILE__)/'fixtures'/'lacador.jpg'
end
