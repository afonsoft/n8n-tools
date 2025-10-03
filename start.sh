#!/usr/bin/env bash

echo "======================================"
echo " Encerrando ambiente anterior (se existir)"
echo "======================================"
docker compose down

echo ""
echo "======================================"
echo " Iniciando ambiente com Docker Compose"
echo "======================================"
docker compose up --build -d

echo ""
echo "Aguardando inicialização dos serviços..."
sleep 20

echo ""
echo "======================================"
echo " URL do serviço n8n"
echo "======================================"
echo "n8n:   http://localhost:5678"
sleep 3

echo ""
echo "Abrindo n8n no navegador..."
# Detecta o sistema operacional / comando disponível para abrir URL
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open http://localhost:5678 >/dev/null 2>&1 &
elif command -v open >/dev/null 2>&1; then
    open http://localhost:5678 >/dev/null 2>&1 &
elif command -v powershell.exe >/dev/null 2>&1; then
    powershell.exe -NoProfile -Command "Start-Process 'http://localhost:5678'" >/dev/null 2>&1 &
elif command -v cmd.exe >/dev/null 2>&1; then
    cmd.exe /C start "" "http://localhost:5678" >/dev/null 2>&1 &
else
    echo "Não foi possível detectar o comando para abrir o navegador. Abra manualmente: http://localhost:5678"
fi

echo ""
echo "Ambiente iniciado com sucesso!"
read -p "Pressione qualquer tecla para fechar esta janela..." -n 1 -r
echo ""
