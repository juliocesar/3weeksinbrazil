load 'deploy'

set :application, '3weeksinbrazil'

set :repository,  'git://github.com/juliocesar/3weeksinbrazil.git'
set :deploy_to,   '/usr/local/3weeksinbrazil.com'
set :deploy_via,  :remote_cache
set :scm,         'git'
set :branch,      ENV['BRANCH'] || 'master'
set :scm_verbose, true

server '3weeksinbrazil.com', :app, :web, :db

namespace :deploy do
  
  desc 'Creates APP/tmp dir'
  task :create_tmp do
    run "mkdir -p #{current_path}/tmp"
  end
  
  desc 'Copies app config in place'
  task :copy_app_config do
    run "cp ~/3weeks-app-config.yml #{current_path}/config/application.yml"
  end
  
  desc 'Restarts Apache'
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
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
  
  task :cold do
    deploy.update
    deploy.start
  end
  
end

after "deploy:symlink", "deploy:create_tmp", "deploy:copy_app_config"