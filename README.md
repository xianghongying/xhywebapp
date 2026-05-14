# XHY WebApp

基于 Flask 的轻量级 Python Web 应用，运行在 Ubuntu 26.04 LTS 容器中。

## 📖 项目简介

这是一个简单的 Flask Web 应用示例项目，用于测试 Docker 多架构镜像构建与推送流程。应用监听 5000 端口，访问根路径返回 `Hello {PROVIDER}!`，其中 `PROVIDER` 可通过环境变量自定义。

### 功能特性

- 🐍 基于 Python 3 + Flask 框架
- 🐳 容器化部署，支持多架构（amd64 / arm64）
- 🔄 支持环境变量 `PROVIDER` 自定义问候语
- 🧪 包含单元测试用例

## 📁 项目结构

```
webapp/
├── Dockerfile              # 多架构 Docker 镜像构建文件
├── README.md               # 项目说明文档
└── webapp/
    ├── app.py              # Flask 应用主入口
    ├── requirements.txt    # Python 依赖包
    ├── tests.py            # 单元测试
    ├── Procfile            # 进程定义文件（Heroku 风格）
    └── .gitignore
```

## 🔧 技术栈

| 组件       | 版本/说明                          |
|:-----------|:-----------------------------------|
| 基础镜像   | Ubuntu 26.04 LTS (Resolute Raccoon) |
| Python     | 3.x（系统自带）                    |
| Web 框架   | Flask                              |
| 容器运行时 | Docker / containerd                |
| 构建工具   | Docker Buildx（多架构）            |

## 🚀 使用方法

### 1. 本地运行（无 Docker）

```bash
cd webapp/
pip3 install -r requirements.txt
python3 app.py
```

访问 http://localhost:5000

自定义问候语：

```bash
PROVIDER=OpenClaw python3 app.py
# 输出: Hello OpenClaw!
```

### 2. Docker 单架构构建 & 运行

```bash
# 构建镜像
docker build -t xhywebapp:latest .

# 运行容器
docker run -d -p 5000:5000 --name webapp xhywebapp:latest

# 自定义 PROVIDER
docker run -d -p 5000:5000 -e PROVIDER=OpenClaw --name webapp xhywebapp:latest
```

### 3. Docker 多架构构建 & 推送

> 前提：已创建并启用多架构 buildx 构建器

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --cache-from=type=local,src=/root/.buildx-cache \
  --cache-to=type=local,dest=/root/.buildx-cache,mode=max \
  -t registry.cn-hangzhou.aliyuncs.com/xhyimages/xhywebapp:v1.0.0 \
  --push .
```

**参数说明：**

| 参数 | 说明 |
|:-----|:-----|
| `--platform linux/amd64,linux/arm64` | 同时构建 x86_64 和 ARM64 两个架构 |
| `--cache-from=type=local,src=/root/.buildx-cache` | 读取本地构建缓存，加速构建 |
| `--cache-to=type=local,dest=/root/.buildx-cache,mode=max` | 写入本地构建缓存（mode=max 缓存所有中间层） |
| `-t registry.cn-hangzhou.aliyuncs.com/xhyimages/xhywebapp:v1.0.0` | 镜像标签（阿里云 ACR 杭州区域） |
| `--push` | 构建完成后直接推送到远程仓库 |

### 4. 拉取 & 运行多架构镜像

```bash
# 拉取镜像（自动匹配当前主机架构）
docker pull registry.cn-hangzhou.aliyuncs.com/xhyimages/xhywebapp:v1.0.0

# 运行
docker run -d -p 5000:5000 --name webapp registry.cn-hangzhou.aliyuncs.com/xhyimages/xhywebapp:v1.0.0
```

## 🧪 运行测试

```bash
cd webapp/
python3 -m pytest tests.py -v
```

## ⚙️ 环境变量

| 变量 | 默认值 | 说明 |
|:-----|:-------|:-----|
| `PROVIDER` | `world` | 问候语中的名称 |
| `PORT` | `5000` | 应用监听端口 |

## 📝 更新日志

- **v1.0.0** — 基础镜像升级至 Ubuntu 26.04 LTS，适配 Python 3，支持多架构构建
