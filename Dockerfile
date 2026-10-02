FROM ghcr.io/cirruslabs/flutter:3.41.2 AS builder

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web --release

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 80
