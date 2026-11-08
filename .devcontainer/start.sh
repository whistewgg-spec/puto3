#!/bin/bash
# Roda TODA vez que o codespace inicia — sobe o container correto
set -e
echo "=== Virtual PC — Start ==="

# Aguarda Docker daemon
for i in $(seq 1 30); do
  docker info >/dev/null 2>&1 && break
  sleep 2
done
docker info >/dev/null 2>&1 || { echo "ERRO: Docker não disponível"; exit 1; }

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
  # Verifica KVM
  if [ -e /dev/kvm ]; then
    echo "KVM disponível ✓"
    KVM_OK=1
  else
    echo "AVISO: /dev/kvm ausente — Windows vai rodar lento sem KVM"
    KVM_OK=0
  fi

  # Ajusta compose se KVM ausente
  if [ "$KVM_OK" = "0" ]; then
    sed -i '/\/dev\/kvm/d' windows.yml 2>/dev/null || true
  fi

  echo "Subindo Windows (porta 8006)..."
  docker compose -f windows.yml up -d
  echo "Windows em background — porta 8006 (15-20min primeira vez)"
fi

echo "=== Start concluído ==="