#!/bin/bash
set -e

service nginx restart

/usr/bin/tail -f /dev/null

exec "$@"