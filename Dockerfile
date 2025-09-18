FROM rust:alpine
# mount secret.rs into /art-of-rally-leaderboard-utils/src/secret.rs

RUN apk add git caddy musl-dev

# leaderboard
WORKDIR /
RUN git clone -b dummy_secret https://github.com/j3sb/art-of-rally-leaderboard-utils.git
WORKDIR /art-of-rally-leaderboard-utils
# the binary can't be built yet bc the secret file is mounted as runtime and not buildtime (also weird bug when trying to rebuild bc cargo thinks the secret file didn't change)
RUN cargo fetch
# so pulling doesn't override secrets.rs
RUN git update-index --assume-unchanged src/secret.rs

# caddy
ENTRYPOINT git pull && cargo run --release && caddy file-server --listen :2015 --root /art-of-rally-leaderboard-utils/public