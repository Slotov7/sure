# Configure Redis for both Sidekiq and direct usage (like the connection check)
# This handles the secure rediss:// connection on Heroku
require "redis"

redis_url = ENV["REDIS_URL"]

if redis_url&.start_with?("rediss://")
  # For secure redis, we often need to disable SSL verification on Heroku
  # because they use self-signed certificates.
  Rails.application.config.redis_options = {
    url: redis_url,
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
else
  Rails.application.config.redis_options = { url: redis_url }
end

# Override how Redis objects are created to use these options
# This helps the SelfHostable check pass
module RedisConnectionPatch
  def new(options = {})
    if options.empty? && ENV["REDIS_URL"].present?
      super(Rails.application.config.redis_options)
    else
      super
    end
  end
end

Redis.singleton_class.prepend(RedisConnectionPatch)
