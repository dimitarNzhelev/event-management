#!/bin/bash

# TODO: move this to a cron job that runs every 5 minutes or so

# Set the target label and the application label selector
TARGET_LABEL_KEY="name"
TARGET_LABEL_VALUE="nextjs-url-shortener-node"
APP_LABEL_SELECTOR="name=nextjs-url-shortener"

# Get the names of all nodes running the application
NODES=$(kubectl get pods -l "$APP_LABEL_SELECTOR" -o=jsonpath='{.items[*].spec.nodeName}' -A)

# Loop through each node and apply the target label
for node in $NODES; do
  echo "Labeling node $node with $TARGET_LABEL_KEY=$TARGET_LABEL_VALUE"
  kubectl label nodes "$node" "$TARGET_LABEL_KEY=$TARGET_LABEL_VALUE" --overwrite
done

