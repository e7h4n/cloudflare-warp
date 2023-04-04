#!/usr/bin/env bash

if [ -f /var/lib/cloudflare-warp/reg.json ]; then
    echo "Forwarding 0.0.0.0:4001 to 127.0.0.1:4000"
    socat TCP-LISTEN:40001,reuseaddr,fork TCP:127.0.0.1:40000 &

    echo "Starting Cloudflare WARP"
    warp-svc
else
    echo "Cloudflare WARP not registered, try start a daemon and register it."
    warp-svc >&/dev/null &
    sleep 5
    echo "Registering Cloudflare WARP"
    warp-cli --accept-tos register
    echo "Setting Cloudflare WARP mode to proxy"
    warp-cli --accept-tos set-mode proxy
    echo "Connecting Cloudflare WARP"
    warp-cli --accept-tos connect
    echo "Done, killing daemon and exiting. This container should work after restart."
    exit 1
fi
