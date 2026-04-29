FROM ghcr.io/cirruslabs/flutter:3.41.7

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN mkdir -p .fvm \
    && ln -sf "$(dirname "$(dirname "$(which flutter)")")" .fvm/flutter_sdk \
    && flutter config --enable-web \
    && flutter precache --web --no-android --no-ios --no-linux --no-windows --no-macos --no-fuchsia

ENV FAIR_ONLINE_RESOURCE_BASE_URL=/resource

EXPOSE 8082 8001 8002

CMD ["dart", "run", "bin/server.dart", "--version", "3.41.7", "--port", "8082"]
