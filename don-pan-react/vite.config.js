import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

/**
 * El backend PHP vive en XAMPP: http://localhost/don_pan/api/*.php
 *
 * El navegador sólo conoce `/api`; Vite la proxiedea hacia Apache reescribiendo
 * a `/don_pan/api`. Así en desarrollo Y en preview ocurre todo en UN origen:
 *   - no hace falta CORS en el día a día,
 *   - la cookie de sesión PHP (HttpOnly, SameSite=Lax) viaja sin ajustes,
 *   - el navegador nunca ve la estructura interna del servidor.
 * Si sirves el build desde otro dominio, define VITE_API_BASE (ver .env.example).
 */
const proxy = {
  '/api': {
    target: process.env.PHP_BACKEND ?? 'http://localhost',
    changeOrigin: true,
    rewrite: (ruta) => `/don_pan${ruta}`,
  },
};

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy,
  },
  preview: {
    port: 4173,
    proxy,
  },
  build: {
    outDir: 'dist',
    // Sin source maps en producción: no se publica el código fuente.
    sourcemap: false,
    chunkSizeWarningLimit: 900,
  },
});
