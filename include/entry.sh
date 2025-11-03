#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e
# Run crontab scheduler
crond -bS
# Opt-out of .NET telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
# Run /usr/local/webone/webone with CONFIG_PATH if it is set
if [ -n "$CONFIG_PATH" ] && [ -f "$CONFIG_PATH" ]; then
    exec /usr/local/webone/webone $CONFIG_PATH
else
    exec /usr/local/webone/webone /etc/webone/webone.conf
fi
