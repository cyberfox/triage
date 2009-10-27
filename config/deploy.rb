set :application, "triage"
set :repository,  "git@github.com:cyberfox/triage.git"
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :web, "fox.vulpine.com"
role :app, "fox.vulpine.com"
role :db, "fox.vulpine.com", :primary => true

set :deploy_to, "/home/triage/app"
set :user, "triage"              # defaults to the currently logged in user

after "deploy:update_code", "deploy:write_sha1"
after "deploy:update_code", "deploy:link_config"

namespace :deploy do
  task :restart do
    run "touch #{release_path}/tmp/restart.txt"
  end

  desc "write sha1 to file"
  task :write_sha1 do
    run "cd #{latest_release} && git show-ref --heads --hash=7 > #{latest_release}/config/HEAD"
  end

  task :link_config do
    run <<-CMD
        cd #{latest_release} &&
        ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml &&
        ln -nfs #{shared_path}/config/site_keys.rb #{latest_release}/config/initializers/site_keys.rb
    CMD
  end
end

