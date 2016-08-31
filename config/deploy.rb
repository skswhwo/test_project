# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'iap'
set :repo_url, 'git@github.com:skswhwo/verify-iap-receipt.git'
set :passenger_restart_with_touch, true 

# rbenv 환경설정
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.3.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails foreman}
set :rbenv_roles, :all # default values

#Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
#append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/application.yml'
append :linked_files, 'config/application.yml'

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
