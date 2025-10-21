FROM hugomods/hugo:latest AS builder

LABEL env=production

WORKDIR /app

COPY . /app

RUN echo "--- Content of hugo.toml ---"
RUN cat /app/hugo.toml || echo "hugo.toml not found or empty"
RUN echo "----------------------------"

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

