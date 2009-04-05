require 'rubygems'
require 'sinatra'
require 'activerecord'

# ActiveRecord::Base.establish_connection(
#   :adapter  => 'sqlite3',
#   :dbfile   => 'naked.db'
# )

get '/' do
  haml :home, :layout => false
end