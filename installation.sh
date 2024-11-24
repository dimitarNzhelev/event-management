#!/bin/bash
helm install url-shortener ./url-shortener-chart
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add selectdb https://charts.selectdb.com
helm repo update
helm install operator selectdb/doris-operator --namespace monitoring
kubectl apply -f monitoring/doris/pv.yaml
helm install -f monitoring/doris/values.yaml doriscluster selectdb/doris --namespace monitoring 

# Wait for Doris FE to be ready
echo "Waiting for Doris FE to be ready..."
kubectl rollout status statefulset/doriscluster-fe -n monitoring

# Apply the Job to initialize the database
kubectl apply -f monitoring/doris/job.yaml

kubectl apply -f monitoring/go-receiver/
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
kubectl apply -f monitoring/node-exporter/cluster-role/
kubectl apply -f monitoring/node-exporter/
# kubectl apply -f ingress/ingress.yaml
# only for minikube
#minikube addons enable ingress