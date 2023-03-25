#!/usr/bin/env ruby
require 'qiniu'
require 'net/http'
require 'json'

# 要上传文件的本地路径
pwd = `pwd`.strip
filePath = `echo #{pwd}/tmp/$(date +%Y-%m-%d).sql.gz`.strip

# 生成数据库备份文件
`pg_dump --dbname=postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:5432/$DATABASE_NAME | gzip > #{filePath}`

# 构建鉴权对象
Qiniu.establish_connection! access_key: ENV['qiniu_ak'],
                            secret_key: ENV['qiniu_sk']

# 要上传的空间
bucket = 'database-bkk'

# 上传后保存的文件名
key = `echo /myapp/$(date +%Y-%m-%d).sql.gz`.strip

# 构建上传策略，上传策略的更多参数请参照 http://developer.qiniu.com/article/developer/security/put-policy.html
put_policy = Qiniu::Auth::PutPolicy.new(
    bucket, # 存储空间
    key,    # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
    3600    # token 过期时间，默认为 3600 秒，即 1 小时
)

# 生成上传 Token
uptoken = Qiniu::Auth.generate_uptoken(put_policy)

# 调用 upload_with_token_2 方法上传
code, result, response_headers = Qiniu::Storage.upload_with_token_2(
     uptoken,
     filePath,
     key,
     nil, # 可以接受一个 Hash 作为自定义变量，请参照 http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#xvar
     bucket: bucket
)

#打印上传返回的信息
puts code
puts result

# 获取文件大小
file_size = `du -sh #{filePath} | awk '{print $1}'`.strip.downcase

# 删除本地文件
`rm #{filePath}`

# 发送到微信消息通知
uri = URI(ENV['qywx_pusher_uri'])
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
req = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ENV['qywx_pusher_ak']}")
req.body =  { "title": "数据库备份","content": "#{ENV['DATABASE_NAME']}已自动备份 文件大小: #{file_size}b 上传状态: #{code}" }.to_json
res = http.request(req)
puts "response #{res.body}"