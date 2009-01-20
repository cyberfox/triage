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

set :mongrel_config, "/etc/mongrel_cluster/#{application}.yml" 

after "deploy:update_code", "deploy:write_sha1"

namespace :deploy do
  task :restart do
    run "cp #{release_path}/config/database.yml.production #{release_path}/config/database.yml"
    run "mongrel_rails cluster::restart -C #{mongrel_config}"
  end

  desc "write sha1 to file"
  task :write_sha1 do
    run "cd #{latest_release} && git show-ref --heads --hash=7 > #{latest_release}/config/HEAD"
  end
end

