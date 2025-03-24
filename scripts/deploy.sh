#!/bin/bash

set -e  # Para o script falhar se qualquer comando falhar

echo "🚀 Iniciando deploy do ambiente Kubernetes para monitoramento..."

# Passo 1: Iniciar Minikube
echo "🔧 Iniciando Minikube..."
minikube start --driver=docker

# Passo 2: Criar Namespace
echo "📌 Criando namespace 'monitoring'..."
kubectl apply -f manifests/namespace.yaml

# Passo 3: Adicionar repositório do Helm e instalar Prometheus Stack
echo "📡 Instalando Prometheus e Grafana..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

# Passo 4: Aguardar os pods estarem prontos
echo "⏳ Aguardando serviços ficarem disponíveis..."
kubectl wait --for=condition=available --timeout=600s deployment/prometheus-grafana -n monitoring

# Passo 5: Obter senha do Grafana
echo "🔑 Obtendo senha do Grafana..."
GRAFANA_PASSWORD=$(kubectl --namespace monitoring get secrets prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d)
echo "Senha do Grafana: $GRAFANA_PASSWORD"

# Passo 6: Exibir acesso ao Grafana
echo "✅ Tudo pronto! Acesse o Grafana com:"
echo "🔗 URL: http://localhost:3000"
echo "👤 Usuário: admin"
echo "🔑 Senha: $GRAFANA_PASSWORD"

# Passo 7: Fazer port-forward do Grafana automaticamente
echo "🔄 Abrindo conexão com Grafana..."
kubectl --namespace monitoring port-forward svc/prometheus-grafana 3000:80
