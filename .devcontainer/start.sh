#!/bin/bash
# Roda TODA vez que o codespace inicia — reconecta Docker e sobe o container
echo "=== Virtual PC — Start ==="

# Reconecta Docker ao data-root persistente
sudo mkdir -p /workspaces/.docker-data
echo '{"data-root":"/workspaces/.docker-data"}' | sudo tee /etc/docker/daemon.json >/dev/null
sudo service docker restart || true
sleep 3

# Aguarda Docker daemon
for i in $(seq 1 30); do
  docker info >/dev/null 2>&1 && break
  echo "Aguardando Docker ($i)..."
  sleep 2
done
docker info >/dev/null 2>&1 || { echo "ERRO: Docker não disponível"; exit 1; }

# Garante pastas de dados
mkdir -p /workspaces/.virtualpc/windows
mkdir -p /workspaces/.virtualpc/linux
mkdir -p /workspaces/.virtualpc/shared

VPC_OS=${VPC_OS:-windows}
REPO_DIR=$(find /workspaces -maxdepth 1 -mindepth 1 -type d | head -1)
[ -z "$REPO_DIR" ] && REPO_DIR="/workspaces"
cd "$REPO_DIR"
echo "Dir: $REPO_DIR | OS: $VPC_OS"

if [ "$VPC_OS" = "linux" ]; then
  echo "Subindo Linux KDE (porta 6080)..."
  docker compose -f linux.yml up -d
  echo "Linux KDE pronto — porta 6080"
else
  # Remove device KVM se não disponível
  [ ! -e /dev/kvm ] && sed -i '/\/dev\/kvm/d' windows.yml 2>/dev/null || true
  echo "Subindo Windows (porta 8006)..."
  docker compose -f windows.yml up -d
  echo "Windows em background — porta 8006 (~15-20min primeira vez)"
fi

echo "=== Start concluído ==="