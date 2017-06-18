# Change to match your CPU core count
workers 2

# Min and Max threads per worker
threads 1, 6

# Default to production
rails_env = ENV['RAILS_ENV'] || 'production'
environment rails_env

# Set up socket location
bind 'tcp://0.0.0.0:3000'

# Logging
stdout_redirect '/pflegebot/log/puma.stdout.log', '/pflegebot/log/puma.stderr.log', true

# Set master PID and state locations
pidfile '/pflegebot/tmp/pids/puma.pid'
state_path '/pflegebot/tmp/pids/puma.state'
activate_control_app

on_worker_boot do
  require 'active_record'
  begin
    ActiveRecord::Base.connection.disconnect!
  rescue
    ActiveRecord::ConnectionNotEstablished
  end
  ActiveRecord::Base.establish_connection(YAML.load_file('/pflegebot/config/database.yml')[rails_env])
end
