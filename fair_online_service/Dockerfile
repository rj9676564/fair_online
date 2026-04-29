FROM ghcr.io/cirruslabs/flutter:3.41.7

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN flutter_bin="$(command -v flutter)" \
    && flutter_sdk_path="${FLUTTER_ROOT:-}" \
    && if [ -z "$flutter_sdk_path" ]; then \
         while [ -L "$flutter_bin" ]; do \
           link_target="$(readlink "$flutter_bin")"; \
           case "$link_target" in \
             /*) flutter_bin="$link_target" ;; \
             *) flutter_bin="$(dirname "$flutter_bin")/$link_target" ;; \
           esac; \
         done; \
         flutter_sdk_path="$(dirname "$(dirname "$flutter_bin")")"; \
       fi \
    && mkdir -p .fvm \
    && ln -sfn "$flutter_sdk_path" .fvm/flutter_sdk \
    && test -f .fvm/flutter_sdk/version \
    && test -x .fvm/flutter_sdk/bin/flutter \
    && flutter config --enable-web \
    && flutter precache --web --no-android --no-ios --no-linux --no-windows --no-macos --no-fuchsia

ENV FAIR_ONLINE_RESOURCE_BASE_URL=/resource

EXPOSE 8082 8001 8002

CMD ["dart", "run", "bin/server.dart", "--version", "3.41.7", "--port", "8082"]
