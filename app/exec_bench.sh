#! /bin/sh
set -eu

cd /home/isucon/torb/bench
curl localhost/initialize
bench -remotes localhost -output /home/isucon/torb/result.json
