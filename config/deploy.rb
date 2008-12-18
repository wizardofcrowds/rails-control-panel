require 'Shell'
set :application, Shell.new.pwd.include?("/") ? Shell.new.pwd.split("/").last : Shell.new.pwd.split("\\").last
set :repository, "."
set :domain_name, 'p1.innogile.com'
set :scm, :none
set :deploy_via, :copy

set :user, "student"
set :runner, "student"
set :password, "jeffcohen"

role :web, 'ec2-75-101-254-49.compute-1.amazonaws.com'
role :app, 'ec2-75-101-254-49.compute-1.amazonaws.com'
role :db, 'ec2-75-101-254-49.compute-1.amazonaws.com', :primary => true

desc "Tasks to execute after code update"
task :after_setup, :roles => [:app, :db] do
  sudo "chown #{user}:#{user} -R #{deploy_to}"
end


namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    phusion_setup
  end
  task :start, :roles => :app do
    phusion_setup
  end
  task :stop, :roles => :app do
    sudo "apache2ctl stop" 
  end
end

def phusion_setup
      sudo "rm -f /etc/apache2/sites-enabled/#{application}"
      sudo "touch /etc/apache2/sites-enabled/#{application}"
      sudo "chmod 777 /etc/apache2/sites-enabled/#{application}"
      sudo "echo '<VirtualHost *:80>' >> /etc/apache2/sites-enabled/#{application}"
      sudo "echo 'ServerName #{domain_name}' >> /etc/apache2/sites-enabled/#{application}"
      sudo "echo 'DocumentRoot /u/apps/#{application}/current/public' >> /etc/apache2/sites-enabled/#{application}"
      sudo "echo '</VirtualHost>' >> /etc/apache2/sites-enabled/#{application}"
      sudo "chmod 744 /etc/apache2/sites-enabled/#{application}"
      sudo "apache2ctl graceful"
  #    run "touch #{current_path}/tmp/restart.txt"  
end