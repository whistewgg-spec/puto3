.PHONY: windows linux stop-windows stop-linux logs-windows logs-linux clean

windows:
	@echo "Iniciando Windows... acesse porta 8006"
	docker compose -f windows.yml up -d

stop-windows:
	docker compose -f windows.yml down

logs-windows:
	docker logs -f windows

linux:
	@echo "Iniciando Linux KDE... acesse porta 6080"
	docker compose -f linux.yml up -d

stop-linux:
	docker compose -f linux.yml down

logs-linux:
	docker logs -f linux-desktop

all: windows linux
stop: stop-windows stop-linux

clean:
	docker system prune -af
	docker volume prune -f