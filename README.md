# MySQL + Keycloak Docker Setup

Este repositório contém scripts para subir rapidamente **MySQL** e **Keycloak** usando Docker, com configuração pronta e usuário administrativo criado.  

Funciona em **Linux** e **Windows (PowerShell)** sem precisar de Docker Compose.

---

## Pré-requisitos

- **Linux**: Docker instalado e funcionando.  
- **Windows**: Docker Desktop com WSL2 habilitado.  
- Ter permissões para executar scripts e criar containers Docker.

---

## Scripts disponíveis

- **Linux**: `start-linux`  
- **Windows**: `start-windows.ps1`  

Ambos configuram:

- MySQL com:
  - Banco: `keycloak`
  - Usuário: `keycloak`
  - Senha: `keycloak`
  - Porta: `3306`  
- Keycloak com:
  - Usuário admin: `admin`
  - Senha admin: `admin123`
  - Porta: `8080`
- Rede Docker exclusiva: `keycloak-net`

---

## Instruções Linux

1. Abra o terminal.  
2. Torne o script executável:
```bash
chmod +x start-linux.sh
``` 
3. Execute o script:
```bash
./start-linux
``` 
4. Acesse: 
 - Keycloak: http://localhost:8080
 - MySQL: localhost:3306 (usuário: keycloak, senha: keycloak)

## Instruções Windows

1. Abra PowerShell como Administrador.
2. Permita execução de scripts (uma vez):
```bash
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
``` 
3. Execute o script:
```bash
.\start-windows.ps1
``` 
4. Acesse: 
 - Keycloak: http://localhost:8080
 - MySQL: localhost:3306 (usuário: keycloak, senha: keycloak)

 
# Observações

- Containers antigos com os mesmos nomes serão automaticamente removidos ao executar os scripts.
- A rede Docker criada é chamada keycloak-net.
- Para volumes persistentes no Windows, os dados são armazenados em:
    - MySQL: C:\dockerdata\mysql
    - Keycloak: C:\dockerdata\keycloak
- No Linux, os volumes não estão configurados por padrão, mas podem ser adicionados ao script se necessário.

# Acessando Keycloak

Abra http://localhost:8080

Usuário administrador: admin
Senha: admin123

Agora você pode criar realms, clientes e gerenciar usuários normalmente.

## Limpar ambiente

Para remover containers criados pelos scripts:
```bash
# Linux
docker rm -f keycloak-database keycloak-server
docker network rm keycloak-net

# Windows (PowerShell)
docker rm -f keycloak-database keycloak-server
docker network rm keycloak-net
``` 

Pronto! Agora você tem um ambiente Keycloak + MySQL funcional e configurado no seu sistema.

### INTEGRAÇÃO REACT

1️⃣ Criar o Realm (se não tiver um)

 - Acesse Keycloak Admin Console (http://localhost:8080/ → admin / admin123).
 - No canto superior esquerdo, clique em Master → Add Realm.
 - Escolha um nome (ex.: myrealm) e crie.

2️⃣ Criar um Client (sua app React)

 - Vá em Clients → Create.
 - Defina:
   - Client ID: react-app (ou qualquer nome da sua app).
   - Client Protocol: openid-connect.
 - Root URL: URL base da sua app (ex.: http://localhost:3000/).
 -  Clique em Save.
 - No Client criado, configure:
    - Access Type: confidential (se tiver backend para trocar o code pelo token) ou public (somente frontend).
    - Standard Flow Enabled: ✅ (Authorization Code).
    - Implicit Flow Enabled: ❌ (não usar, menos seguro).
    - Direct Access Grants Enabled: opcional, para login via API.
    - Valid Redirect URIs: http://localhost:3000/*.
    - Web Origins: http://localhost:3000.
 - Salve as alterações.

⚠️ Se você usar confidential, vai precisar do Client Secret no backend para trocar o code por token.

7️⃣ Configurar temas customizados (opcional)

 - Se você quiser trocar cores, logotipo e botões da tela de login, vá em Realm Settings → Themes.
 - Defina:
    - Login Theme: nome do tema que você montou (my-theme).