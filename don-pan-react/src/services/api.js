/**
 * Único punto de contacto con la API PHP del backend.
 *
 * ¿Por qué un solo archivo? Para que validación, cabecera CSRF, cookies de
 * sesión y manejo de errores vivan en UN sitio. Cualquier llamada nueva se
 * agrega aquí; el resto de la app nunca toca `fetch` directamente.
 *
 * En desarrollo Vite proxiedea `/api` → `http://localhost/don_pan/api`
 * (mismo origen para el navegador). En producción, define VITE_API_BASE.
 */

const BASE = (import.meta.env.VITE_API_BASE ?? '/api').replace(/\/+$/, '');

let csrfToken = '';

export function setCsrfToken(token) {
  if (typeof token === 'string') csrfToken = token;
}

export function getCsrfToken() {
  return csrfToken;
}

export class ApiError extends Error {
  constructor(message, { status = 0, code = 'red' } = {}) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code;
  }
}

async function pedir(ruta, { method = 'GET', body } = {}) {
  const cabeceras = { Accept: 'application/json' };
  if (csrfToken) cabeceras['X-CSRF-Token'] = csrfToken;
  if (body !== undefined) cabeceras['Content-Type'] = 'application/json';

  let res;
  try {
    res = await fetch(`${BASE}${ruta}`, {
      method,
      headers: cabeceras,
      // 'include' manda la cookie de sesión PHP (misma origen en dev).
      credentials: 'include',
      body: body === undefined ? undefined : JSON.stringify(body),
    });
  } catch {
    throw new ApiError('No se pudo contactar con el servidor. ¿Está XAMPP con Apache corriendo?', {
      code: 'red',
    });
  }

  let datos = null;
  try {
    datos = await res.json();
  } catch {
    datos = null; // respuesta no JSON (p. ej. 404 de Apache)
  }

  if (!res.ok) {
    throw new ApiError(datos?.message ?? `El servidor respondió ${res.status}.`, {
      status: res.status,
      code: datos?.error ?? 'http',
    });
  }

  return datos;
}

export const api = {
  /** Devuelve { authenticated, user, csrf } y crea la sesión PHP + token. */
  consultarSesion: () => pedir('/session.php'),

  /** POST { usuario, password } → { user, csrf }. Lanza ApiError si falla. */
  iniciarSesion: (usuario, password) =>
    pedir('/login.php', { method: 'POST', body: { usuario, password } }),

  /** Destruye la sesión en el servidor. */
  cerrarSesion: () => pedir('/logout.php', { method: 'POST', body: {} }),

  /** KPIs del panel (requiere sesión). */
  obtenerResumen: () => pedir('/resumen.php'),

  /** Catálogo de productos en lectura (requiere sesión). */
  listarProductos: () => pedir('/productos.php'),
};
