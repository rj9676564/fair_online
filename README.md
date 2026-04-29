# Fair Online Platform

`fair_online` 已整理为可独立迁移的新仓库形态，包含前端、后端、Docker
编排和 GitHub Actions 镜像构建流程。

## 仓库结构

```text
.
├── fair_online/           # Flutter Web 前端
├── fair_online_service/   # Dart/Flutter 后端服务
├── .github/workflows/     # GitHub Actions
├── docker-compose.yml     # 一键部署编排
├── .env.example           # 部署环境变量样例
└── scripts/               # 部署与导出脚本
```

## 本地一键启动

先准备环境变量：

```bash
cp .env.example .env
```

然后启动：

```bash
./scripts/deploy_fair_online.sh
```

默认访问地址：

```text
http://localhost:8080
```

## Docker Compose

当前 `docker-compose.yml` 会启动两个服务：

- `fair-online-web`
  前端站点，负责静态资源和反向代理
- `fair-online-service`
  后端 API、资源服务和编译预览能力

默认代理关系：

- `/` -> 前端页面
- `/service/` -> 后端 API
- `/resource/` -> 后端资源服务
- `/backend-web/` -> 后端内置 web 静态服务

## 环境变量

根目录 `.env.example` 当前包含：

```dotenv
FAIR_ONLINE_PORT=8080
FAIR_ONLINE_API_BASE_URL=/service/
FAIR_ONLINE_RESOURCE_BASE_URL=/resource
```

常见调整：

- 修改外部访问端口：调整 `FAIR_ONLINE_PORT`
- 修改 API 前缀：调整 `FAIR_ONLINE_API_BASE_URL`
- 修改资源前缀：调整 `FAIR_ONLINE_RESOURCE_BASE_URL`

## GitHub Actions 镜像发布

工作流文件：

- [.github/workflows/build-images.yml](./.github/workflows/build-images.yml)

发布规则：

- `pull_request`
  只构建校验，不推送镜像
- `push` 到 `main`
  自动构建并推送镜像到 `GHCR`
- `push` tag，如 `v1.0.0`
  自动构建并推送 tag 镜像
- `workflow_dispatch`
  支持手动触发

当前会构建两个镜像：

- `ghcr.io/rj9676564/fair-online-web`
- `ghcr.io/rj9676564/fair-online-service`

默认标签策略：

- 分支名
- tag 名
- commit sha
- `latest`
  仅默认分支生效

## 使用 GHCR 的前置条件

首次使用前建议确认：

1. 仓库 `Settings -> Actions -> General` 允许工作流读写包
2. 账号 `rj9676564` 对 GHCR 有推送权限
3. 需要公开镜像时，在 GitHub Packages 页面手动调整可见性

说明：

- 工作流使用 `GITHUB_TOKEN` 登录 GHCR
- 不需要额外创建 Docker Hub 凭证

## 导出到新仓库

如果要从当前工作区导出一个干净的新仓库目录：

```bash
./scripts/export_fair_online_repo.sh /path/to/fair_online_repo
```

导出后初始化并推送：

```bash
cd /path/to/fair_online_repo
git init
git checkout -b main
git remote add origin git@github.com:rj9676564/fair_online.git
git add .
git commit -m "chore: initialize fair online platform"
git push -u origin main
```

## 当前状态说明

这套仓库骨架已经包含：

- `fair_online` 前端可配置 API 地址
- `fair_online_service` 可配置资源地址
- `docker-compose.yml` 一键部署入口
- GHCR 镜像构建工作流

当前机器未安装 `docker` CLI，所以我没有在本机完成 `docker compose config`
和镜像构建的实际执行验证；工作流文件和 Compose 文件已按仓库当前结构对齐。
