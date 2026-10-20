# 🍞 Don Pan · Front-end (React + Vite)

Interfaz de la panadería **Don Pan**. Parte del sistema de gestión (evidencia
**GA7-220501096-AA4-EV03**, SENA). Habla con el backend PHP del proyecto madre
vía una API JSON autenticada por sesión.

## 🧰 Stack

| Capa | Tecnología |
|---|---|
| UI | React 19 + React Router 7 |
| Build | **Vite 8** (antes CRA; ver nota al final) |
| Backend | PHP 8.2 + MariaDB (XAMPP), API en `../api/*.php` |
| Estilos | CSS con variables de diseño propias (`src/styles/tokens.css`), sin frameworks externos ni CDNs |

## ▶️ Requisitos

* Node.js **20.19+** (Vite 8 lo exige) y npm
* XAMPP con **Apache** (puerto 80) y **MySQL** (puerto 3306) corriendo

## ⚙️ Instalación y ejecución

```bash
cd don-pan-react
npm install
npm run dev        # http://localhost:5173  (proxy /api -> Apache)
npm run build      # genera dist/
npm run preview    # sirve dist/ con el mismo proxy
```

1. Arranca Apache y MySQL desde el panel de XAMPP.
2. Abre `http://localhost:5173`.
3. Entra con **`admin` / `1234`** (crear más usuarios en la app PHP).

> El proxy de Vite reescribe `/api` → `http://localhost/don_pan/api`
> (ver `vite.config.js`). Así el navegador sólo ve un origen y la cookie de
> sesión PHP funciona sin CORS. Para producción, usa `.env` (ver
> `.env.example`).

## 🗂️ Estructura

```
don-pan-react/
├── index.html                 # Punto de entrada (Vite, en la raíz)
├── vite.config.js             # Proxy de la API + build sin source maps
├── .env.example               # Plantilla de configuración (copiar a .env)
├── public/                    # Estáticos + .htaccess de distribución
└── src/
    ├── main.jsx               # Montaje + importación de estilos globales
    ├── App.jsx                # Rutas (lazy) y guardias
    ├── styles/                # tokens / global / layout / componentes
    ├── context/AuthContext.jsx# Estado de sesión en memoria
    ├── services/api.js        # ÚNICO punto que llama a la API
    ├── components/
    │   ├── AppLayout.jsx      # Shell con sidebar y topbar
    │   ├── ProtectedRoute.jsx # Guardia de autenticación y rol
    │   ├── ErrorBoundary.jsx  # Recuperación ante errores de render
    │   └── ui.jsx             # Piezas visuales compartidas
    └── pages/                 # Login, Dashboard, Productos, Ventas...
```

## 🔐 Decisiones de seguridad

| Tema | Decisión | Por qué |
|---|---|---|
| Sesión | Cookie **HttpOnly** de PHP; en JS sólo vive el perfil (nombre/rol) en `useState` | `localStorage` es legible por cualquier script: con XSS, un atacante robaría el token |
| CSRF | Token por cabecera `X-CSRF-Token` en toda escritura | Requiere cabecera personalizada, imposible de forzar desde otra origen |
| Autorización | `ProtectedRoute` en la UI **y** validación de sesión/rol en cada endpoint PHP | La UI nunca es autoridad: sin la capa servidor, basta con inspeccionar el código |
| Enumeración | Error genérico «Usuario o contraseña incorrectos» | Revelar «ese usuario no existe» ayuda a adivinar cuentas |
| Rate limit | 5 intentos → bloqueo de 1 minuto (sesión) | Fuerza bruta básica disuadida |
| Contraseñas | `password_verify()` con bcrypt, jamás comparación de texto | Hashes con sal, resistentes a rainbow tables |
| Tokens de sesión | `session_regenerate_id(true)` al autenticar | Evita *session fixation* |
| CORS | Lista blanca en `api/bootstrap.php`, nunca `*` | Con credenciales, `*` invalida la protección |
| Secretos | `.gitignore` bloquea **todos** los `.env`; sólo se versiona `.env.example` | Evita filtrar credenciales al repositorio |
| Producción | `sourcemap: false`, CSP + `X-Frame-Options` vía `.htaccess`, `robots.txt: Disallow` | Menos superficie de ataque y sin fuga de código fuente |

> La sesión se gestiona **igual** que en la app PHP original: mismo servidor,
> mismo `session_start()`, mismos intentos fallidos. No hay dos sistemas de
> autenticación en paralelo.

## 🧪 Verificación rápida de la API

```bash
# Estado de sesión (crea además el token CSRF)
curl -c jar.txt http://localhost:5173/api/session.php

# Login (sustituye TOKEN por el valor de "csrf" anterior)
curl -b jar.txt -c jar.txt -H "X-CSRF-Token: TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"usuario":"admin","password":"1234"}' \
     http://localhost:5173/api/login.php
```

## 📌 Nota sobre la migración

La versión anterior usaba `react-scripts` (Create React App) pero quedó en la
versión fantasma `0.0.0`, que **no arranca nunca**: `npm start` y `npm build`
fallaban. CRA está además archivado. Se migró a Vite conservando React 19 y las
mismas rutas; el código de páginas no cambió de significado, sólo de formato.
