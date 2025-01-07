FROM alpine:latest

ARG PB_VERSION=0.24.1

RUN apk add --no-cache \
    unzip \
    ca-certificates

# Download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# Copy the local migrations directory into the image
COPY ./pb_migrations /pb/pb_migrations

# Copy the local hooks directory into the image
COPY ./pb_hooks /pb-fardtjanst/pb_hooks

# Clean up any macOS metadata files
RUN find /pb-fardtjanst/pb_migrations /pb-fardtjanst/pb_hooks -name "._*" -delete

EXPOSE 8090

# Set the default command to serve PocketBase
CMD ["/pb-fardtjanst/pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb-fardtjanst/pb_data", "--migrationsDir=/pb-fardtjanst/pb_migrations", "--hooksDir=/pb-fardtjanst/pb_hooks"]