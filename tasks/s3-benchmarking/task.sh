#!/bin/bash

tar xzvf app/big_app.tar.gz
export APP_PATH=big_app

chmod +x ./s3-benchmark-binary/s3-benchmarking
./s3-benchmark-binary/s3-benchmarking
