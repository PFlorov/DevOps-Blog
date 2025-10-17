---
title: "First Automated Blog Deployment: Pushing to K3s"
date: 2025-10-17T10:00:00+03:00
draft: false
tags: ["DevOps", "CI/CD", "GitHub Actions", "K3s", "Docker", "Cloudflare"]
---

So I just got my blog set up with an automated CI pipeline. Now, I can write a post, commit, push to GitHub, and it goes live on my devops-blog repo in the future will be in the k3s-homelab repo integrated with a full CI/CD pipeline. It's been a challenging process, but worth it.

### The Setup

Getting this far meant a few steps. My K3s homelab runs on old laptops, hosting services like Grafana and Prometheus. The goal was always to integrate my blog into this.

The pipeline uses **GitHub Actions**. It takes my Hugo Markdown, builds it into a static site, and then puts it into a small Nginx Docker image. This image then goes to GitHub Container Registry. This part alone taught me a lot about Docker multi-stage builds, Nginx configurations for Hugo, and the specifics of GitHub Actions like Buildx and GHCR permissions. I definitely ran into some `denied` and `invalid tag` errors. Each one was a lesson.

### How the CI Works:

*   **Hugo Static Site Generation:** My Markdown posts become static HTML, CSS, and JavaScript.
*   **Docker Multi-Stage Build:** My `Dockerfile` builds the Hugo site in one stage, then copies only the necessary static files to a `nginx:alpine` image in a second stage. This keeps the final image small.
*   **Custom Nginx Config:** I learned Nginx needed a specific `nginx.conf` to handle Hugo's clean URLs (like `/my-post/` instead of `/my-post.html`). It also handles caching and security headers.
*   **GitHub Actions Automation:** A workflow in `.github/workflows/` automates the build and push to `ghcr.io`. Images are tagged with `latest` and the Git commit SHA for tracking.

### My Cloudflare Tunnel / Cert-Manager Lesson

One tricky part was getting HTTPS working with Cert-Manager and my Cloudflare Tunnel. ACME HTTP-01 challenges, which Cert-Manager uses for domain verification with Let's Encrypt, weren't completing. The main problem was my `cloudflared` config. Its general rules for `blog.k3s-homelab.org` were grabbing the `/.well-known/acme-challenge/` path.

The solution was to add a very specific rule in my `cloudflared` ConfigMap. I put it *before* the general blog rule. This new rule sends all ACME challenge requests directly to Traefik's **HTTP port 80** entrypoint. That's `http://traefik.kube-system.svc.cluster.local:80`. This ensures validation happens over plain HTTP, avoiding any conflicts. It was a key lesson in network ingress ordering.

### Next Steps: Full CD

Now that image building and pushing is automated, the next step is Continuous Deployment. I want to automatically update my K3s `Deployment` in the homelab whenever a new image is pushed. This means securely connecting GitHub Actions to my K3s cluster. I'll share how that goes soon.

Getting code from `git push` to a container registry automatically feels like a big win.
