FROM ghcr.io/cirruslabs/flutter:3.41.7

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN chmod +x docker-entrypoint.sh

RUN flutter config --enable-web \
    && flutter precache --web --no-android --no-ios --no-linux --no-windows --no-macos --no-fuchsia

ENV FAIR_ONLINE_RESOURCE_BASE_URL=/resource

EXPOSE 8082 8001 8002

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["--version", "3.41.7", "--port", "8082"]
