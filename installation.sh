#!/bin/bash

helm install url-shortener ./url-shortener-chart

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install -f monitoring/values.yaml kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring


helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set-string controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb" \
  --set controller.metrics.enabled=true \
  --set controller.metrics.service.annotations."prometheus\.io/scrape"="\"true\"" \
  --set controller.metrics.service.annotations."prometheus\.io/port"="\"10254\"" \
  --set controller.metrics.serviceMonitor.enabled=true \
  --set controller.metrics.serviceMonitor.namespace=monitoring \
  --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus"

kubectl apply -f monitoring/service-monitors/
kubectl apply -f monitoring/node-exporter/
# kubectl apply -f ingress/ingress.yaml

# only for minikube
#minikube addons enable ingress