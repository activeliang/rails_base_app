# 安装postgresql数据库
sudo apt install -y postgresql postgresql-contrib
# sudo systemctl start postgresql.service
# database password command: sudo -u postgres psql
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'kkkkkkkkkk';"
# set password!!!!
sudo -u postgres createdb myapp

# 修改/etc/postgresql/9.5/main/postgresql.conf -> listen 0.0.0.0
# 修改/etc/postgresql/9.5/main/pg_hba.conf ->+ host all all 0.0.0.0/0 md5
echo "listen_addresses = '0.0.0.0'" >> /etc/postgresql/*/main/postgresql.conf
echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/*/main/pg_hba.conf
service postgresql restart


# 安装redis
wget http://download.redis.io/redis-stable.tar.gz \
&& tar xvzf redis-stable.tar.gz \
&& cd redis-stable \
&& make && make install

# make MALLOC=libc 若make报错，可以用这个指令

mkdir /etc/redis
mkdir /var/redis
mkdir /var/redis/6379
cp utils/redis_init_script /etc/init.d/redis_6379
curl http://my-global-bucket.oss-cn-guangzhou.aliyuncs.com/mac/redis-1.conf -o /etc/redis/6379.conf
update-rc.d redis_6379 defaults
/etc/init.d/redis_6379 start

# 安装docker  
wget -qO- https://get.docker.com | sh

# 安装docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 安装nginx
apt install -y nginx