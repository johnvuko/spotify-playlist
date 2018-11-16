workers ENV.fetch("WEB_CONCURRENCY") { 1 }
threads_count = ENV.fetch("RAILS_THREADS") { 5 }
threads threads_count, threads_count

environment ENV.fetch("RAILS_ENV") { "development" }

if ENV['RAILS_ENV'] == 'production'
  bind 'unix://tmp/sockets/puma.sock'
  daemonize true
else
  port ENV.fetch("PORT") { 3000 }
end

before_fork do
  ActiveRecord::Base.connection.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

preload_app!

plugin :tmp_restart
