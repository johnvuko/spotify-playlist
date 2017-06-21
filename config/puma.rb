threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

environment ENV.fetch("RAILS_ENV") { "development" }

if ENV['RAILS_ENV'] == 'production'
  pidfile 'tmp/pids/puma.pid'
  state_path 'tmp/pids/puma.state'
  bind 'unix://tmp/sockets/puma.sock'
  daemonize true
else
  port ENV.fetch("PORT") { 3000 }
end

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart
