FROM alpine:latest

# Build arguments for versioning and instance naming
ARG PB_VERSION=0.24.1
ARG INSTANCE_NAME=loppis-pb

RUN apk add --no-cache \
    unzip \
    ca-certificates

# Download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /${INSTANCE_NAME}/ && \
    rm /tmp/pb.zip

# Create a directory for instance-specific data
RUN mkdir -p /${INSTANCE_NAME}/pb_data

# Uncomment and modify these if you need migrations and hooks
# COPY ./pb_migrations /${INSTANCE_NAME}/pb_migrations
# COPY ./pb_hooks /${INSTANCE_NAME}/pb_hooks

# Clean up any macOS metadata files if needed
# RUN find /${INSTANCE_NAME}/pb_migrations /${INSTANCE_NAME}/pb_hooks -name "._*" -delete

EXPOSE 8090

# Use instance-specific paths in the command
CMD ["sh", "-c", "/${INSTANCE_NAME}/pocketbase serve --http=0.0.0.0:8090 --dir=/${INSTANCE_NAME}/pb_data"]