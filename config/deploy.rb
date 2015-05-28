# config valid only for current version of Capistrano
lock '3.4.0'

# set :stage, :production

set :application, 'tap'
set :repo_url, 'git@github.com:zanloy/tap.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/srv/rails/tap'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :linked_dirs, %w{pids log sockets}
set :linked_files, %w{.env}

# Fix permissions
set :file_permissions_paths, ['/srv/rails/picard/shared']
set :file_permissions_user, 'apps'

namespace :foreman do

  desc 'Export the Procfile to upstart'
  task :export do
    on roles(:app) do
      within release_path do
        execute :sudo, "/home/apps/.rbenv/shims/foreman export upstart /etc/init -a tap -u apps -l /srv/rails/tap/shared/log"
      end
    end
  end

  desc 'Start the application services'
  task :start do
    on roles(:app) do
      execute :sudo, "service tap start"
    end
  end

  desc 'Stop the application services'
  task :stop do
    on roles(:app) do
      execute :sudo, "service tap stop"
    end
  end

  desc 'Restart the application services'
  task :restart do
    on roles(:app) do
      execute :sudo, "service tap restart"
    end
  end

end

namespace :deploy do

  task :restart do
    on roles(:app) do
      invoke 'foreman:export'
      #on roles(:app) do
      #  within release_path do
      #    execute :rake, "assets:precompile"
      #  end
      #end
      invoke 'foreman:restart'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
