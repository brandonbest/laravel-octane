#!/usr/bin/env bash

set -e

exec /usr/local/bin/php -d variables_order=EGPCS /app/artisan octane:start --server=swoole --workers=4 --task-workers=6 --max-requests=500

# Run Octane without Nginx
# exec /usr/local/bin/php -d variables_order=EGPCS /app/artisan octane:start --server=swoole --host=0.0.0.0 --port=80 --workers=4 --task-workers=6 --max-requests=500