#!/bin/bash

# Descobrir o diretório do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Diretórios de dados persistentes
MYSQL_DATA="$SCRIPT_DIR/mysql-data"
KC_DATA="$SCRIPT_DIR/keycloak-data"
KC_THEMES="$SCRIPT_DIR/keycloak-themes"

echo "🧹 Preparando diretórios de dados e temas..."
mkdir -p "$MYSQL_DATA" "$KC_DATA" "$KC_THEMES"
chmod 777 "$MYSQL_DATA" "$KC_DATA" "$KC_THEMES"

echo "🧹 Limpando containers antigos..."
docker rm -f keycloak-server keycloak-database 2>/dev/null

# Criar rede Docker (se não existir)
docker network inspect keycloak-net >/dev/null 2>&1 || docker network create keycloak-net

echo "🚀 Subindo MySQL..."
docker run -d \
  --name keycloak-database \
  --network keycloak-net \
  -e MYSQL_ROOT_PASSWORD=keycloak \
  -e MYSQL_DATABASE=keycloak \
  -e MYSQL_USER=keycloak \
  -e MYSQL_PASSWORD=keycloak \
  -p 3306:3306 \
  -v "$MYSQL_DATA:/var/lib/mysql" \
  mysql:8

# Esperar MySQL iniciar
echo "⏳ Aguardando MySQL ficar pronto..."
until docker exec keycloak-database mysqladmin ping -h "localhost" --silent; do
    sleep 2
done
echo "✅ MySQL pronto!"

echo "🚀 Subindo Keycloak em HTTP com tema customizado..."
docker run -d \
  --name keycloak-server \
  --network keycloak-net \
  -p 8080:8080 \
  -e KC_DB=mysql \
  -e KC_DB_URL_HOST=keycloak-database \
  -e KC_DB_USERNAME=keycloak \
  -e KC_DB_PASSWORD=keycloak \
  -e KC_DB_DATABASE=keycloak \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin123 \
  -e KC_HTTP_ENABLED=true \
  -e KC_HTTP_PORT=8080 \
  -v "$KC_DATA:/opt/keycloak/data" \
  -v "$KC_THEMES:/opt/keycloak/themes" \
  quay.io/keycloak/keycloak:25.0.2 start-dev

# Esperar alguns segundos e checar status
sleep 5

echo "                                                "
echo "                                                "
echo "                                                "
echo "                                                "
echo "------------------------------------------------"
echo "|                                              |"
echo "|   ✅ MySQL e Keycloak subidos com sucesso!   |"
echo "|   🌐 Keycloak: http://localhost:8080/        |"
echo "|   🔐 Credentials: admin / admin123           |"
echo "|                                              |"
echo "------------------------------------------------"
