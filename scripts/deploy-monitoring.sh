#!/bin/bash

echo "📌 Criando o namespace..."
kubectl apply -f manifests/namespace.yaml

echo "📡 Instalando Prometheus e Grafana..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

echo "✅ Monitoramento instalado com sucesso!"
