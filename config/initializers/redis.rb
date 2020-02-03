REDIS = if Rails.env.test?
          MockRedis.new
        else
          Redis.new(
              host: ENV['REDIS_HOST'],
              port: ENV['REDIS_PORT']
          )
        end
