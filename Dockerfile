FROM rust:alpine

RUN apk add git caddy musl-dev libc-dev make

# leaderboard
WORKDIR /
RUN git clone -b dummy_secret https://github.com/j3sb/art-of-rally-leaderboard-utils.git
WORKDIR /art-of-rally-leaderboard-utils
RUN cargo run --release

# caddy
WORKDIR /
ENTRYPOINT caddy file-server --listen :2015 --root /art-of-rally-leaderboard-utils/public