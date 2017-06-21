set :output, 'log/cron.log'

every 30.minutes do
  runner "User.spotify"
end
