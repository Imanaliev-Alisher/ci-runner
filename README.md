# Self-Hosted GitHub Actions Runner in Docker

This repository contains a configuration for running a self-hosted GitHub Actions runner inside a Docker container using `docker-compose`. The runner automatically registers with the specified repository and can be scaled for parallel CI/CD task execution.

## 📁 Repository Structure

- `docker-compose.yml` — defines the `runner` service configuration
- `Dockerfile` — builds an Ubuntu 22.04-based image with GitHub Actions Runner pre-installed
- `start.sh` — script that registers the runner with GitHub and starts it
- `.env.example` — example environment variables file (create `.env` from this template)

---

## ⚙️ Requirements

- Docker
- Docker Compose
- GitHub Personal Access Token (PAT) with `repo` and `admin:repo_hook` scopes

---

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/your-org/github-runner-docker.git
cd github-runner-docker
```

### 2. Configure environment variables

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Edit `.env` and set your values:
- `OWNER` - GitHub username or organization
- `REPO` - Repository name
- `TOKEN` - GitHub Personal Access Token
- `RUNNER_NAME` - Name for your runner
- `LABELS` - Comma-separated labels (e.g., `self-hosted,linux,docker`)
- `DOCKER_GID` - Docker socket group ID (on Linux: `stat -c '%g' /var/run/docker.sock`)

### 3. Build and run

```bash
docker compose up --build -d
```

### 4. Verify runner registration

Check that your runner appears in GitHub:
- Navigate to your repository → Settings → Actions → Runners

### 5. Stop the runner

```bash
docker compose down
```

---

## 🔧 Configuration

### Scaling Runners

To run multiple runner instances, edit the `replicas` value in [docker-compose.yml](docker-compose.yml):

```yaml
deploy:
  replicas: 2  # Number of runner instances
```

### Resource Limits

Adjust CPU and memory limits in [docker-compose.yml](docker-compose.yml):

```yaml
resources:
  limits:
    cpus: '1.0'
    memory: 1G
  reservations:
    cpus: '0.5'
    memory: 512M
```

---

## 🐛 Troubleshooting

### Runner not appearing in GitHub

1. Check container logs: `docker compose logs -f`
2. Verify TOKEN has correct permissions
3. Ensure OWNER/REPO values are correct

### Permission denied errors

On Linux, ensure correct DOCKER_GID:
```bash
stat -c '%g' /var/run/docker.sock
```

---

## 📝 License

MIT