# Self-Hosted GitHub Actions Runner in Docker

This repository contains a configuration for running a self-hosted GitHub Actions runner inside a Docker container using `docker-compose`. The runner automatically registers with the specified repository and launches two instances (replicas) for parallel CI/CD task execution.

## 📁 Repository Structure

- `docker-compose.yml` — defines the `runner` service and configures scaling using Docker Swarm.
- `Dockerfile` — builds an Ubuntu-based image with GitHub Actions Runner pre-installed.
- `start.sh` — script that registers the runner with GitHub and starts it.
- `.env` — environment file containing required variables (not tracked by Git, should be created manually).

---

## ⚙️ Requirements

- Docker
- Docker Compose
- GitHub Personal Access Token (PAT) with `repo` and `admin:repo_hook` scopes

---

## 🧪 Installation

### 1. Clone the repository

```bash
git clone https://github.com/your-org/github-runner-docker.git
cd github-runner-docker
```

### 2. Set values ​​for the argument

```bash
export DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
```

### 3. Build and run the compose file

```bash
docker compose up --build
```

# Самостоятельно размещенный GitHub Actions Runner в Docker

Этот репозиторий содержит конфигурацию для запуска собственного GitHub Actions Runner в Docker-контейнере с помощью `docker-compose`. Runner автоматически регистрируется в указанном репозитории и запускается в двух экземплярах (репликах) для параллельного выполнения задач CI/CD.

## 📁 Состав репозитория

- `docker-compose.yml` — описывает сервис `runner` и настраивает масштабируемость через Docker Swarm.
- `Dockerfile` — создает образ Ubuntu с предустановленным GitHub Actions Runner.
- `start.sh` — скрипт, выполняющий автоматическую регистрацию раннера в GitHub и его запуск.
- `.env` — файл с переменными окружения (игнорируется Git и должен быть создан вручную).

---

## ⚙️ Требования

- Docker
- Docker Compose
- Персональный токен доступа GitHub с правами на `repo` и `admin:repo_hook`

---

## 🧪 Установка

### 1. Клонируй репозиторий

```bash
git clone https://github.com/your-org/github-runner-docker.git
cd github-runner-docker
```

### 2. Установите значения для аргумента

```bash
export DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
```

### 3. Соберите и запустите compose файл

```bash
docker compose up --build
```