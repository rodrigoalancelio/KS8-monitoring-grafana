#!/bin/bash

echo "🔧 Instalando Minikube, kubectl e Helm..."
sudo dnf install -y minikube kubectl

echo "🚀 Iniciando Minikube..."
minikube start --driver=docker

echo "✅ Minikube iniciado com sucesso!"
