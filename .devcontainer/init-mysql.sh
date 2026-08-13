#!/bin/bash

# Se ocorrer erro o script aborta
set -e

# Exibe uma mensagem no terminal
echo "Iniciando MySQL..."
service mysql start


echo "Aguardando MySQL ficar pronto..."
# Verifica se o MySQL iniciou
# Tentando verificar o próprio até 30 vezes
for tentativa in $(seq 1 30); do
# Se passou das 30 vezes e não teve resposta, o script aborta
    if mysqladmin ping --silent; then
        echo "MySQL pronto."
        break
    fi
    sleep 1
done

# Se passou das 30 tentativas sem resposta, para o script com erro.
if ! mysqladmin ping --silent; then
    echo "Erro: MySQL não respondeu a tempo." >&2
    exit 1
fi

echo "Configurando banco..."

# Envia para o MYSQL os comandos a seguir
# CHARACTER E COLLATE; Define as codificações dos caracteres
# CREATE USER; Cria um usuario
# GRANT; Atribui permissões para o usuário
# FLUSH; Confirma as alterações de permissões
mysql <<EOF
CREATE DATABASE IF NOT EXISTS ecommerce
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'cuidoka'@'%' IDENTIFIED BY 'q1w2e3';

GRANT ALL PRIVILEGES ON ecommerce.* TO 'cuidoka'@'%';

FLUSH PRIVILEGES;
EOF

echo "MySQL configurado com sucesso!"
