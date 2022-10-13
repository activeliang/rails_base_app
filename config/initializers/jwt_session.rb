JWTSessions.encryption_key = "123456"
# JWTSessions.access_exp_time = 8
JWTSessions.access_exp_time = 2 * 60 * 60 # 1 hour in seconds
# JWTSessions.access_exp_time = 6 # 1 hour in seconds
JWTSessions.refresh_exp_time = 604800 * 12 # 1 week in seconds
JWTSessions.refresh_cookie = "jwt_refresh"
JWTSessions.token_store = :redis, {
  redis_host: ENV['REDIS_HOST'],
  redis_port: ENV['REDIS_PORT'],
  redis_db_name: "0",
  token_prefix: "jwt_myapp"
}