FROM hugomods/hugo:latest AS builder

LABEL env=production

WORKDIR /app

COPY . /app

RUN hugo --buildDrafts --buildFuture --cleanDestinationDir

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/public /usr/share/nginx/html

EXPOSE 80

