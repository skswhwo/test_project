# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'first'
set :repo_url, 'git@github.com:skswhwo/test_project.git'
set :passenger_restart_with_touch, true 

#Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/application.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
set :passenger_roles, :all
set :rails_env, :production

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:api), in: :groups, limit: 3, wait: 10 do
      # do nothing
    end
  end

  task :reset_db do
    on roles(:db), in: :groups, limit: 3, wait: 10 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:drop"
          execute :rake, "db:create"
          execute :rake, "db:migrate"
        end
      end
    end
  end
end
