#!/bin/bash

helm install url-shortener ./url-shortener-chart

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.watchNamespace=""

helm upgrade --install -f monitoring/values.yaml kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring

kubectl apply -f monitoring/service-monitors/
kubectl apply -f ingress/ingress.yaml

minikube addons enable ingress