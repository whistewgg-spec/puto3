#!/bin/bash
# Roda UMA vez na criação do codespace — instala dependências
set -e
echo "=== Virtual PC — Install ==="
export DEBIAN_FRONTEND=noninteractive

# Aguarda Docker daemon (docker-in-docker inicia em background)
echo "Aguardando Docker daemon..."
for i in $(seq 1 60); do
  docker info >/dev/null 2>&1 && echo "Docker pronto (tentativa $i)" && break
  sleep 2
done
docker info >/dev/null 2>&1 || { echo "ERRO: Docker não disponível"; exit 1; }

echo "Docker: $(docker version --format '{{.Server.Version}}')"
echo "Compose: $(docker compose version --short)"
echo "=== Install concluído ==="