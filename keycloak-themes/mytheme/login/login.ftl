<#-- login.ftl -->
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>${msg("loginTitle")!}</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/login.css">

    <style>
        body {
            margin: 0;
            font-family: sans-serif;
            background: #f5f5f5;
        }
        .login-container {
            display: flex;
            min-height: 100vh;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .login-left, .login-right {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-left .bg-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .login-right {
            flex-direction: column;
            text-align: center;
            padding: 2rem;
        }
        .login-right form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            width: 100%;
            max-width: 300px;
        }
        .login-right input {
            padding: 0.8rem;
            border-radius: 0.5rem;
            border: 1px solid #ccc;
            font-size: 1rem;
        }
        .login-right button {
            padding: 0.8rem;
            border: none;
            border-radius: 0.5rem;
            font-weight: bold;
            color: white;
            cursor: pointer;
            background-color: #007BFF;
        }
        .footer {
            margin-top: 2rem;
            font-size: 0.8rem;
            color: #666;
        }
        /* Loader */
        .loader-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }
        .loader {
            border: 6px solid #ccc;
            border-top: 6px solid #888;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg);}
            100% { transform: rotate(360deg);}
        }
    </style>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const params = new URLSearchParams(window.location.search);
            const pValue = params.get("p");
            let payload = {};

            if (pValue) {
                try {
                    payload = JSON.parse(atob(pValue));
                    console.table(payload)
                } catch(e) {
                    console.error("Erro ao decodificar payload:", e);
                }
            }

            const imgParam = payload.imagem || 'https://i.ibb.co/BKd6h18g/bg-lines-blue.jpg';
            const colorParam = payload.cor || '#007BFF';

            const title = document.querySelector(".login-right h1");
            if (title) title.style.color = colorParam;

            // Atualiza imagem e cor do botão
            const bgImg = document.querySelector(".login-left .bg-image");
            if (bgImg) bgImg.src = imgParam;

            const btn = document.querySelector(".login-right button");
            if (btn) btn.style.setProperty('background-color', colorParam, 'important');

            // Mostra a página e remove loader
            document.querySelector(".login-container").style.opacity = "1";
            document.querySelector(".loader-overlay").remove();
        });
    </script>
</head>
<body>
    <!-- Loader -->
    <div class="loader-overlay">
        <div class="loader"></div>
    </div>

    <div class="login-container">
        <div class="login-left">
            <img class="bg-image" src="https://i.ibb.co/BKd6h18g/bg-lines-blue.jpg" alt="Background">
        </div>

        <div class="login-right">
            <h1>Portal de Acessos</h1>
            <p>Clique no botão abaixo para entrar</p>

            <form id="kc-form-login" action="${url.loginAction}" method="post">
                <input type="text" name="username" placeholder="Usuário" autofocus required>
                <input type="password" name="password" placeholder="Senha" required>
                <button type="submit">Entrar</button>
            </form>

            <div class="footer">&copy;2025 NAI IT - V1.5.6</div>
        </div>
    </div>
</body>
</html>
