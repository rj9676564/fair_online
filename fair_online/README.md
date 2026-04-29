# fair_online

`fair_online` 是 Fair Online 的 Flutter Web 前端模块。

## 本地启动

这个前端依赖 `fair_online_service` 提供的接口，默认本地服务地址为：

```text
http://127.0.0.1:8082/service/
```

推荐启动顺序：

```bash
cd fair_online_service
FLUTTER_VERSION="3.41.8" fvm dart run grinder serve
```

```bash
cd fair_online
fvm flutter pub get
fvm flutter run -d chrome \
  --dart-define=FAIR_ONLINE_API_BASE_URL=http://127.0.0.1:8082/service/
```

如果不传 `--dart-define`，开发模式也会默认回落到
`http://127.0.0.1:8082/service/`。

## 服务端部署

这个模块适合部署成静态站点，再通过反向代理或环境变量把接口流量转发到
`fair_online_service`。

### 方案一：同域部署，推荐

- 前端站点：`https://your-domain.com/`
- 后端接口：`https://your-domain.com/service/`

这种方式下，前端默认会请求 `/service/`，不需要重新改代码。

### 方案二：前后端分域

构建时或运行时显式指定 API 地址：

```bash
fvm flutter build web --release \
  --dart-define=FAIR_ONLINE_API_BASE_URL=https://api.example.com/service/
```

或者使用 Docker 运行时环境变量：

```bash
FAIR_ONLINE_API_BASE_URL=https://api.example.com/service/ \
./scripts/start_docker.sh
```

## Docker 一键启动

在仓库根目录执行：

```bash
cp .env.example .env
./scripts/deploy_fair_online.sh
```

启动后访问：

```text
http://<server-ip>:8080
```

默认配置：

- 前端入口：`/`
- API 代理：`/service/`
- 资源代理：`/resource/`

如果要改端口或代理前缀，编辑根目录 `.env`：

```dotenv
FAIR_ONLINE_PORT=8080
FAIR_ONLINE_API_BASE_URL=/service/
FAIR_ONLINE_RESOURCE_BASE_URL=/resource
```

## Nginx 反向代理示例

如果前后端同域部署，可以让 Nginx 同时托管前端静态文件并转发 `/service/`：

```nginx
server {
  listen 80;
  server_name your-domain.com;

  root /srv/fair_online;
  index index.html;

  location / {
    try_files $uri $uri/ /index.html;
  }

  location /service/ {
    proxy_pass http://127.0.0.1:8082/service/;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
```

## 部署要点

- `fair_online` 本身不是独立业务后端，必须连 `fair_online_service`
- 线上推荐把接口统一挂到 `/service/`
- 如果用了跨域域名，记得同时处理后端 CORS
- 现在也支持直接用仓库根目录 `docker-compose.yml` 一键部署
