#!/bin/bash

tar xzvf app/big_app.tar.gz
export APP_PATH=big_app
./backup-and-restore-ci/tasks/s3-benchmarking/s3-benchmarking
