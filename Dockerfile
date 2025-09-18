FROM rust:alpine
# mount secret.rs into /art-of-rally-leaderboard-utils/src/secret.rs

RUN apk add git caddy musl-dev

# leaderboard
WORKDIR /
RUN git clone -b dummy_secret https://github.com/j3sb/art-of-rally-leaderboard-utils.git
WORKDIR /art-of-rally-leaderboard-utils
# so the binary is built when running for the first time
RUN cargo run --release
# so pulling doesn't override secrets.rs
RUN git update-index --assume-unchanged src/secret.rs

# caddy
ENTRYPOINT git pull && cargo run --release && caddy file-server --listen :2015 --root /art-of-rally-leaderboard-utils/public