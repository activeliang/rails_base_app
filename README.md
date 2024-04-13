### 新项目脚手架

#### 项目简介：
> 这主要是一个配置好的新项目的脚手架，新项目可以基于此快速开始。下面是此项目的一些特点介绍：

- Rails7.0 + vite + vue 前后端分离, 但项目一体化。
- 前端UI用的是[vuetify](https://vuetifyjs.com/en/components/all/#containment)
- 集成了零宕机部署脚本。
- 集成便捷脚本，方便连接到生产服务器，进入console查看log
- 集成[tailwind css](https://tailwindcss.com/docs)
- 集成jwt token做auth登录验证
- 集成exception-track做报错收集
- 集成数据库定时备份脚本.docker/backup.rb，定时备份数据库保存到七牛云存储

#### 使用简要说明：
0. 本地电脑，安装clash梯子软件，保证7890号代理端口能正常使用。

1. clone回本地后，在.docker目录下做一些配置：
  - .docker/Dockerfile第5行里的activeliang改成你自己的dockerhub用户名
  - .docker/Dockerfile里的第4行取消注释，第5行注释掉（仅在首次打包时操作，后面可取消此操作能回快打包速度）
  - 把.docker/deploy.sh.example重命名为.docker/deploy.sh，这个脚本部署用的。把里面的ip改成你要部署的ip, 里头的mypassword改成你的实际的数据库密码, 里头的activeliang需要改成自己的dockerhub的用户名。
  - .docker/env_development.env.example改名为.docker/env_development.env主要放本地env配置
  - .docker/env_production.env.example改名为.docker/env_production.env主要放生产环境env配置，部署时会一起部署到服务器。
  - .docker/nginx.conf 里边放的是nginx配置，部署时按需更改。
  - .docker/remote.sh 连接服务器用的脚本。里边的Ip改为你的服务器Ip
  - .docker/init.sh.example改名为.docker/init.sh，里的数据库密码mypassword改成自己的。

2. 执行以下指令给项目进行更名，比如你想改成test_app，这样改：
```
./bin/rename-project test_app TestApp
```
第一个参数是项目名，第二个参数是项目名的大写骆峰写法

3. 本地启动项目：
```
docker compose up 
```

4. 部署：
-  .docker/init.sh脚本是基础依赖，需要先在服务器上执行安装，直接复制在服务器上执行即可。
- 在本地执行部署脚本
```
.docker/deploy.sh 
```

5. 部署好之后，一些便捷连接服务器的指令：
进入生产环境console:
```
.docker/remote.sh console
```

查看生产环境log:
```
.docker/remote.sh tail 
```

进入生产环境web所在的容器内部：
```
.docker/remote.sh sh
```

登录进服务器：
```
.docker/remote.sh bash
```

