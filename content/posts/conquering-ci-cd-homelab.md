---
title: "Conquering CI/CD: My GitOps Pipeline is Live!"
date: 2025-10-21T14:00:00+03:00 # Adjust date/time if needed
draft: false
slug: "conquering-ci-cd"
tags: ["DevOps", "CI/CD", "GitOps", "FluxCD", "K3s", "GitHub Actions"]
---

Hey everyone,

The full CI/CD pipeline for my DevOps blog is now fully operational! After a solid journey of learning and quite a bit of troubleshooting, I can confirm that a `git push` on my blog repo now automatically results in a live update on my K3s homelab cluster. This feels like a huge step forward in my automation goals.

### The Full Cycle

It's truly satisfying to see the entire process work seamlessly:

1.  **Content Creation:** I write a blog post in Markdown and commit it to my `devops-blog` repository.
2.  **GitHub Actions (CI):**
    *   My workflow automatically triggers.
    *   It pulls the latest code, including new posts.
    *   It builds a fresh Docker image of my Hugo site.
    *   This image is then pushed to GitHub Container Registry, tagged with `latest` and a unique Git SHA.
3.  **GitHub Actions (CD Trigger):**
    *   The same GitHub Actions workflow then checks out my separate `k3s-homelab` repository.
    *   It uses `yq` to update the `blog-deployment.yaml` file in `k3s-homelab` to point to the newly built Docker image tag.
    *   It commits this manifest change and pushes it back to the `k3s-homelab` repo.
4.  **Flux CD (GitOps Controller on K3s):**
    *   Flux, running directly on my K3s cluster, is constantly monitoring the `k3s-homelab` repository.
    *   It detects the new commit with the updated `blog-deployment.yaml`.
    *   It pulls the changes and applies them to the cluster.
    *   Kubernetes (orchestrated by Flux) then pulls the new Docker image, updates the running blog pods, and brings the new content live.

### Key Learnings Along the Way

This wasn't a straight path. I encountered and overcame several important challenges:

*   **Docker Buildx Caching:** Figuring out how to properly configure `docker/setup-buildx-action` to leverage GitHub Actions cache.
*   **GHCR Naming Conventions:** Learning that repository names *must* be lowercase for Docker image tags in GitHub Container Registry.
*   **GHCR Permissions:** Granting the `GITHUB_TOKEN` explicit `packages: write` permission to push images to GHCR from an organization-owned repo.
*   **Flux CD Bootstrap & `kubeconfig`:** Correctly installing Flux on K3s and ensuring my local `flux` CLI used the right `kubeconfig` to connect via Tailscale.
*   **Kubernetes Manifest Namespaces:** Ensuring all my manifests explicitly declared their `metadata.namespace` for Flux's `Kustomization` to apply them correctly.
*   **`yq` Syntax:** A surprisingly tricky one! Getting the exact `yq -i 'expression' file.yaml` syntax right for in-place YAML updates within GitHub Actions.

My homelab now has a robust, secure, and automated deployment process, which is exactly what I aimed for!
