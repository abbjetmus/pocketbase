FROM alpine:latest

# Build arguments for versioning and instance naming
ARG PB_VERSION=0.24.1

RUN apk add --no-cache \
    unzip \
    ca-certificates

# Download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /loppis-pb/ && \
    rm /tmp/pb.zip

# Copy the local data directory into the image
COPY ./pb_data /loppis-pb/pb_data

# Clean up any macOS metadata files
RUN find /loppis-pb/pb_data "._*" -delete

VOLUME /loppis-pb/pb_data
EXPOSE 8090

# Use instance-specific paths in the command
CMD ["/loppis-pb/pocketbase", "serve", "--http=0.0.0.0:8090"]