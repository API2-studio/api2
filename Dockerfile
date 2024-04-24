FROM debian:bookworm-slim as app    
# Install locales package and generate en_US.UTF-8
RUN apt-get update && apt-get install -y locales && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen en_US.UTF-8

# Install the runtime dependencies
RUN apt-get update && \
    apt-get install -y openssl build-essential libncurses5 libssl-dev locales imagemagick && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set locale to UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
# Set the working directory
WORKDIR /app

# Copy the build release from current directory to the working directory
COPY . ./
COPY .entrypoint.sh ./docker-entrypoint.sh
COPY ./secrets ./secrets
# Ensure the script and executables are executable
RUN chmod +x _build
RUN chmod +x ./docker-entrypoint.sh
ENTRYPOINT [ "./docker-entrypoint.sh" ]
# CMD ["./bin/dynamic", "start"]

# Expose the relevant port
EXPOSE 4000

# Run the application
CMD ["./_build/prod/rel/dynamic/bin/dynamic", "start"]


