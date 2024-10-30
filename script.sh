
#!/bin/bash

helm install url-shortener ./url-shortener-chart

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install -f monitoring/values.yaml kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring

kubectl apply -f monitoring/service-monitors/