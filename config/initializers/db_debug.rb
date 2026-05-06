# Debug database configuration on startup
Rails.application.config.after_initialize do
  config = ActiveRecord::Base.connection_db_config.configuration_hash
  puts "================ DATABASE DEBUG ================"
  puts "Host: #{config[:host]}"
  puts "Port: #{config[:port]}"
  puts "Database: #{config[:database]}"
  puts "User: #{config[:user] || config[:username]}"
  puts "SSL Mode: #{config[:sslmode]}"
  puts "Using DATABASE_URL? #{ENV['DATABASE_URL'].present?}"
  puts "================================================"
end
