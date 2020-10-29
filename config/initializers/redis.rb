require 'redis'

uri = URI.parse Settings.redis.host
redis = Redis.new host: uri.host, port: uri.port, password: uri.password