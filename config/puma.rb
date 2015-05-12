workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads 1, threads_count

app_dir = File.expand_path("../..", __FILE__)
directory app_dir
shared_dir = "#{app_dir}/shared"

bind "unix://#{app_dir}/sockets/puma.sock"

stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

pidfile "#{app_dir}/pids/puma.pid"
state_path "#{app_dir}/pids/puma.state"

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
