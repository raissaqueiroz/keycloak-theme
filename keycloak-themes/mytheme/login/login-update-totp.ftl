<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Portal de Acessos - Autenticação Dois Fatores</title>
    <!-- CSS -->
    <link rel="stylesheet" href="${url.resourcesPath}/css/login.css">

    <!-- JS -->
    <script src="${url.resourcesPath}/js/login.js" defer></script>
</head>
<body>
    <div class="loader-overlay">
        <div class="loader"></div>
    </div>

    <div class="login-container">
        <div class="login-left">
            <img class="bg-image" src="https://i.ibb.co/BKd6h18g/bg-lines-blue.jpg" alt="Background">
        </div>

        <div class="login-right">
            <h1>Portal de Acessos</h1>
            <p>Abra seu Aplicativo de Autenticação de Dois Fatores e Verifique o Código Gerado.</p>
            
            <form id="kc-form-login" action="${url.loginAction}" method="post">
                <input type="text" name="token" placeholder="Digite o código gerado aqui" autofocus required>
                <button type="submit">Validar</button>
            </form>

            <div class="footer">&copy;2025 NAI IT - V1.5.6</div>
        </div>
    </div>
</body>
</html>
