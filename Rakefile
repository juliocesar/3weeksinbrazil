desc 'Helper task for loading the environment'
task :environment do
  require File.join(File.dirname(__FILE__), 'app.rb')
end

# http://adam.blog.heroku.com/past/2009/2/28/activerecord_migrations_outside_rails/
namespace :db do
  desc 'Migrate the database'
  task(:migrate => :environment) do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate('db/migrate')
  end
end