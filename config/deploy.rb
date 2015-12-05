# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'yep_mention'
set :repo_url, 'git@github.com:CatchChat/yep-mention.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/u/apps/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, ['.env', 'config/newrelic.yml', '.ruby-version'])

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets')

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_ruby, '2.2.2'
set :rbenv_custom_path, '/opt/rbenv'

# Goliath
set :goliath_worker_processes, 2
set :goliath_start_port, 9000
set :goliath_pidfile_path, 'tmp/pids'
set :goliath_env, fetch(:stage)

namespace :deploy do

  task :start do
    invoke 'goliath:start'
    invoke 'bluepill:load'
  end

  task :restart do
    invoke 'goliath:restart'
  end

  task :stop do
    invoke 'bluepill:quit'
    invoke 'goliath:stop'
  end

  after 'deploy:published', 'goliath:restart', 'bluepill:load'
end
