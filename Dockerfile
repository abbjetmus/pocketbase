FROM alpine:latest

ARG PB_VERSION=0.23.5

RUN apk add --no-cache \
    unzip \
    ca-certificates

# Download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# Copy the local migrations directory into the image
COPY ./pb_migrations /pb/pb_migrations

# Copy the local hooks directory into the image
COPY ./pb_hooks /pb/pb_hooks

# Clean up any macOS metadata files
RUN find /pb/pb_migrations /pb/pb_hooks -name "._*" -delete

EXPOSE 8090

# Set the default command to serve PocketBase
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb/pb_data", "--migrationsDir=/pb/pb_migrations", "--hooksDir=/pb/pb_hooks"]