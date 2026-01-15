FROM rust:alpine
# mount art-of-rally.toml into /art-of-rally-leaderboard-utils/src/art-of-rally.toml

RUN apk add git caddy musl-dev supercronic --no-cache

# leaderboard
WORKDIR /
RUN git clone https://github.com/sornas/art-of-rally-leaderboard-utils.git
WORKDIR /art-of-rally-leaderboard-utils

RUN cargo build --release

# cronjob
RUN echo "0 * * * * cd /art-of-rally-leaderboard-utils && git pull && cargo run --release >> /var/log/cron.log 2>&1" >> /cronjob
RUN touch /var/log/cron.log


# caddy
ENTRYPOINT supercronic /cronjob && cargo run --release && caddy file-server --listen :2015 --root /art-of-rally-leaderboard-utils/public