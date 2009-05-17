load 'deploy'

set :application, '3weeksinbrazil'

set :repository,  'git://github.com/juliocesar/3weeksinbrazil.git'
set :deploy_to,   '/usr/local/3weeksinbrazil.com'
set :deploy_via,  :remote_cache
set :scm,         'git'
set :branch,      ENV['BRANCH'] || 'master'
set :scm_verbose, true


server '3weeksinbrazil.com', :app, :web

namespace :deploy do
  
  desc 'Restarts Apache'
  task :restart do
    run "#{current_path}/tmp/restart.txt"
  end
  
  desc 'Ensures site is enabled and starts Apache'
  task :start do
    sudo "a2ensite 3weeksinbrazil.com"
    sudo "apache2ctl graceful"
  end
  
  desc 'Disables virtual host'
  task :stop do
    sudo "a2dissite 3weeksinbrazil.com"
    sudo "apache2ctl graceful"
  end
  
end    