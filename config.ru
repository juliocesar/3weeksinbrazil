require 'rubygems'

gem 'rack', '0.9.1'
require 'rack'

gem 'sinatra', '0.9.1.1'
require 'sinatra'

set :run => false,
    :env => :production

require File.join(File.dirname(__FILE__), 'app')

require 'noie'

use NoIE

run Sinatra::Application
