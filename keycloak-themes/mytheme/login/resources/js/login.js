function decodeB64UrlToJSON(b64) {
    try {
        if (!b64) return {};
        // base64url -> base64
        b64 = b64.replace(/-/g, '+').replace(/_/g, '/');
        // padding
        const pad = b64.length % 4;
        if (pad) b64 += '='.repeat(4 - pad);
        
        return JSON.parse(atob(b64));
    } catch (e) {
        console.error('Falha ao decodificar p:', e);
        return {};
    }
}

function getThemePayload() {
    const params = new URLSearchParams(window.location.search);
    const pQS = params.get('p');
    if (pQS) {
        const payload = decodeB64UrlToJSON(pQS);
        try {
            sessionStorage.setItem('kc_theme_payload', JSON.stringify(payload));
        } catch {

        }
            
        return payload;
    }

    try {
        const cached = sessionStorage.getItem('kc_theme_payload');
        return cached ? JSON.parse(cached) : {};
    } catch {
        return {};
    }
}

function applyTheme(payload) {
    const img = payload.imagem || 'https://i.ibb.co/BKd6h18g/bg-lines-blue.jpg';
    const cor = payload.cor || '#007BFF';

    const bgImg = document.querySelector('.login-left .bg-image');
    if (bgImg) bgImg.src = img;

    const title = document.querySelector('.login-right h1');
    if (title) title.style.color = cor;

    const btn = document.querySelector('.login-right button');
    if (btn) btn.style.setProperty('background-color', cor, 'important');

    const qr = document.querySelector('#kc-totp-secret-qr-code');
    if (qr) qr.style.setProperty('border', '1px dashed ' + cor, 'important');
}

document.addEventListener('DOMContentLoaded', () => {
    const payload = getThemePayload();
    applyTheme(payload);

    const container = document.querySelector('.login-container');
    if (container) container.style.opacity = '1';
    const overlay = document.querySelector('.loader-overlay');
    if (overlay) overlay.remove();
});