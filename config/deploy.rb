set :application, `pwd`.strip.include?("/") ? `pwd`.strip.split("/").last : `pwd`.strip.split("\\").last
set :repository, "."
set :domain_name, 'innogile.com'
set :scm, :none
set :deploy_via, :copy
set :deploy_port, 9290
 
set :user, "student"
set :runner, "student"
set :password, "jeffcohen"

role :web, 'ec2-75-101-254-49.compute-1.amazonaws.com'
role :app, 'ec2-75-101-254-49.compute-1.amazonaws.com'
role :db, 'ec2-75-101-254-49.compute-1.amazonaws.com', :primary => true

desc "Tasks to execute after code update"
task :after_setup, :roles => [:app, :db] do
  sudo "chown #{user}:#{user} -R #{deploy_to}"
  run "thin config -C #{deploy_to}/thin.yml --servers 1 --port 9290 --chdir #{current_path} --environment production"
end

namespace :deploy do
  %w(start stop restart).each do |action| 
     desc "#{action} the Thin processes"  
     task action.to_sym do
       find_and_execute_task("thin:#{action}")
    end
  end 
end

namespace :thin do  
  %w(start stop restart).each do |action| 
  desc "#{action} the app's Thin Cluster"  
    task action.to_sym, :roles => :app do  
      run "thin #{action} -c #{current_path} -C #{deploy_to}/thin.yml" 
    end
  end
end

