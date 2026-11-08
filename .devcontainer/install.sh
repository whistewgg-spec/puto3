#!/bin/bash
# Roda UMA vez na criação do codespace — instala dependências e configura persistência
set -e
echo "=== Virtual PC — Install ==="

# Configura docker data-root em /workspaces (PERSISTE entre stop/start)
echo "Configurando Docker root persistente..."
sudo mkdir -p /workspaces/.docker-data
echo '{"data-root":"/workspaces/.docker-data"}' | sudo tee /etc/docker/daemon.json >/dev/null
sudo service docker restart || true
sleep 3

# Aguarda Docker daemon
echo "Aguardando Docker daemon..."
for i in $(seq 1 60); do
  docker info >/dev/null 2>&1 && echo "Docker pronto ($i)" && break
  sleep 2
done
docker info >/dev/null 2>&1 || { echo "ERRO: Docker não disponível"; exit 1; }

# Cria pastas de dados persistentes
mkdir -p /workspaces/.virtualpc/windows
mkdir -p /workspaces/.virtualpc/linux
mkdir -p /workspaces/.virtualpc/shared

echo "Docker: $(docker version --format '{{.Server.Version}}')"
echo "Compose: $(docker compose version --short)"
echo "=== Install concluído ==="