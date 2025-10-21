FROM hugomods/hugo:latest AS builder

LABEL env=production

WORKDIR /app

COPY . /app

RUN hugo --buildDrafts --cleanDestinationDir

RUN ls -lR /app/public
RUN echo "--- Content of /app/public/index.html ---"
RUN cat /app/public/index.html || echo "index.html not found in public/"

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/public /usr/share/nginx/html

EXPOSE 80

