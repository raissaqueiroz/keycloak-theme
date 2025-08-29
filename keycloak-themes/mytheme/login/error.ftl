<#-- error.ftl mínimo para Keycloak -->
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>${msg("errorTitle")!} - Keycloak</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; color: #333; margin: 0; padding: 50px; }
        .error-container { max-width: 600px; margin: auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { color: #c00; }
        p { margin-top: 10px; }
    </style>
</head>
<body>
<div class="error-container">
    <h1>${msg("errorTitle")!}!</h1>
    <p>${msg("unexpectedError")}</p>
    <p><a href="${url.loginUrl}">Voltar para o login</a></p>
</div>
</body>
</html>
