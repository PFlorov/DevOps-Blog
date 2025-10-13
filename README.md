# 📝 Plamen's DevOps Journey Blog

- Personal blog documenting my DevOps learning journey with K3s home lab.

## 🚀 Tech Stack

- **Hugo** static site generator with Ananke theme
- **Docker** multi-stage build with Nginx
- **GitHub Actions** CI/CD pipeline
- **Kubernetes** deployment to K3s home lab cluster --> https://github.com/PFlorov/k3s-homelab

## 🔄 How It Works

1. Write post in Markdown
2. Push to `main` branch
3. GitHub Actions builds Docker image
4. Auto-deploys to K3s cluster
5. Blog updates automatically

## 📁 Structure

├── content/posts/ # Blog posts
├── .github/workflows/ # CI/CD pipeline
├── Dockerfile # Container build
├── nginx.conf # Web server config
└── hugo.toml # Hugo config

## 🎯 Learning Goals

- Kubernetes & container orchestration
- CI/CD automation with GitHub Actions
- Infrastructure as Code practices
- DevOps workflows and GitOps

Part of my [k3s-homelab](https://github.com/PFlorov/k3s-homelab) project.
