require 'spec/rake/spectask'

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

namespace :posts do
  desc 'Imports all posts from POSTS_ROOT'
  task(:import => :environment) do
    if ENV['DIRNAME']
      Post.create_or_update_from_directory POSTS_ROOT/ENV['DIRNAME']
    else
      Dir[POSTS_ROOT/'*'].each do |dir|
        next unless File.directory? dir
        puts "Importing #{dir}..."
        post = Post.create_or_update_from_directory dir
        post.save!  # force montage generation
      end
    end
  end

  desc 'Delete photos from a post'
  task(:delete_photos => :environment) do
    if ENV['PHOTO'] 
      unless photo = Photo.find_by_image_file_name(ENV['PHOTO'])
        puts "Couldn't find photo with name #{ENV['PHOTO']}"
        exit(1)
      end
      puts "Deleting #{photo.inspect}..."
      photo.destroy
      post = photo.post
      post.build_montage!
      post.build_body!
    elsif ENV['POST']
      unless post = Post.find_by_slug(ENV['POST'])
        puts "Couldn't find post with slug #{ENV['POST']}. Bailing out..."
        exit(1)
      end
      post.photos.each do |photo|
        puts "Deleting #{photo.inspect}..."
        photo.destroy
      end
      post.build_montage!
      post.build_body!
    end
  end
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
end
