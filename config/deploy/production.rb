set :rails_env, "production"
set :user, "root"
set :password, "RhTD85Fnd"
set :runner, "nobody"

set :deploy_to, "#{directory_path}/#{stage}"

# =============================================================================
# ROLES
# =============================================================================
role :web, "68.233.16.141"
role :app, "68.233.16.141"
role :db,  "68.233.16.141", :primary => true

# =============================================================================
# TASKS
# =============================================================================
namespace :deploy do
  task :restart, :roles => :app do
    run "export RAILS_ENV=production"

    run "rm -rf #{current_path}/log"
    run "rm -rf #{current_path}/public/system"
    #    run "rm -rf #{current_path}/config/database.yml"

    run "ln -s #{directory_path}/#{stage}/shared/log #{current_path}/log"
    #    run "ln -s #{directory_path}/#{stage}/shared/config/database.yml #{current_path}/config/database.yml"
    run "ln -s #{directory_path}/#{stage}/shared/system #{current_path}/public/system"

    run "chown -Rf nobody #{directory_path}/#{stage}/current/"
    #    run "chmod 666 -R #{current_path}/log"
    run "chmod 777 #{current_path}/public/system"

    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "clear data cart gift, challenge, wishlist and facebook bet"
  task :reset, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake db:reset_data"
  end
  
end

after 'deploy:update_code' do
  run "rm -rf #{release_path}/tmp/*"
  #  run "touch #{File.join(current_path,'log','production.log')}"
  run "cd #{release_path}; RAILS_ENV=production bundle install"
  #  run "cd #{release_path}; RAILS_ENV=production bundle exec rake db:migrate"
  #  run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:clean"
  run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
   
end