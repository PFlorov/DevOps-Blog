FROM klakegg/hugo:latest-ext AS builder

LABEL env=production

WORKDIR /app

COPY . /app

RUN echo "--- Content of hugo.toml ---"
RUN cat /app/hugo.toml || echo "hugo.toml not found or empty"
RUN echo "----------------------------"

RUN echo "--- Listing source content/posts directory ---"
RUN ls -lR /app/content/posts
RUN echo "--- Content of /app/content/posts/first-automated-blog-deploy.md ---"
RUN cat /app/content/posts/first-automated-blog-deploy.md || echo "First post MD not found"
RUN echo "--- Content of /app/content/posts/conquering-ci-cd-homelab.md ---"
RUN cat /app/content/posts/conquering-ci-cd-homelab.md || echo "Conquering CI/CD post MD not found"
RUN echo "----------------------------------------------"

RUN hugo \
    --environment "production" \
    --baseURL "https://blog.k3s-homelab.org" \
    --buildDrafts \
    --cleanDestinationDir

RUN hugo --buildDrafts --cleanDestinationDir

RUN ls -lR /app/public
RUN echo "--- Content of /app/public/index.html ---"
RUN cat /app/public/index.html || echo "index.html not found in public/"

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/public /usr/share/nginx/html

EXPOSE 80

