#!/bin/bash

gcloud compute instances create reddit-full\
  --image reddit-full-1553989394 \
  --machine-type=f1-micro\
  --tags puma-server
