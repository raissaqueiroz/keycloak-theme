# Verifica se o Docker está rodando
try {
    docker info > $null 2>&1
} catch {
    Write-Error "❌ Docker não está rodando. Por favor, inicie o Docker Desktop antes de continuar."
    exit 1
}

# Diretório do script
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Diretórios de dados persistentes
$MYSQL_DATA = Join-Path $SCRIPT_DIR "mysql-data"
$KC_DATA = Join-Path $SCRIPT_DIR "keycloak-data"
$KC_THEMES = Join-Path $SCRIPT_DIR "keycloak-themes"

Write-Host "🧹 Preparando diretórios de dados e temas..."
foreach ($dir in @($MYSQL_DATA, $KC_DATA, $KC_THEMES)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

Write-Host "🧹 Limpando containers antigos..."
docker rm -f keycloak-server, keycloak-database 2>$null

# Criar rede Docker (se não existir)
$netExists = docker network ls --format '{{.Name}}' | Select-String "keycloak-net"
if (-not $netExists) {
    docker network create keycloak-net | Out-Null
}

Write-Host "🚀 Subindo MySQL..."
docker run -d `
    --name keycloak-database `
    --network keycloak-net `
    -e MYSQL_ROOT_PASSWORD=keycloak `
    -e MYSQL_DATABASE=keycloak `
    -e MYSQL_USER=keycloak `
    -e MYSQL_PASSWORD=keycloak `
    -p 3306:3306 `
    -v "${MYSQL_DATA}:/var/lib/mysql" `
    mysql:8 | Out-Null

# Espera o MySQL inicializar com barra de progresso
Write-Host "⏳ Aguardando MySQL ficar pronto..."
$progress = 0
do {
    Start-Sleep -Seconds 3
    docker exec keycloak-database mysqladmin ping -h 127.0.0.1 --silent
    $mysqlReady = $LASTEXITCODE -eq 0
    $progress = ($progress + 5) % 100
    Write-Progress -Activity "Iniciando MySQL..." -Status "$progress% completo" -PercentComplete $progress
} until ($mysqlReady)
Write-Host "✅ MySQL pronto!"

Write-Host "🚀 Subindo Keycloak em HTTP com tema customizado..."
docker run -d `
    --name keycloak-server `
    --network keycloak-net `
    -p 8080:8080 `
    -e KC_DB=mysql `
    -e KC_DB_URL_HOST=keycloak-database `
    -e KC_DB_USERNAME=keycloak `
    -e KC_DB_PASSWORD=keycloak `
    -e KC_DB_DATABASE=keycloak `
    -e KEYCLOAK_ADMIN=admin `
    -e KEYCLOAK_ADMIN_PASSWORD=admin123 `
    -e KC_HTTP_ENABLED=true `
    -e KC_HTTP_PORT=8080 `
    -v "${KC_DATA}:/opt/keycloak/data" `
    -v "${KC_THEMES}:/opt/keycloak/themes" `
    quay.io/keycloak/keycloak:25.0.2 start-dev | Out-Null

Start-Sleep -Seconds 5

# Mensagem final
Write-Host ""
Write-Host "------------------------------------------------"
Write-Host "|                                              |"
Write-Host "|   ✅ MySQL e Keycloak subidos com sucesso!   |"
Write-Host "|   🌐 Keycloak: http://localhost:8080/        |"
Write-Host "|   🔐 Credentials: admin / admin123           |"
Write-Host "|                                              |"
Write-Host "------------------------------------------------"