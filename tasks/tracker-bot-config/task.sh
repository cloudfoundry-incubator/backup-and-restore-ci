#!/bin/sh

set -e

cp bosh-backup-and-restore-meta/tracker-bot/config.yml relint-trackerbot/
mkdir -p relint-trackerbot-with-config/
cp -r relint-trackerbot/. relint-trackerbot-with-config
