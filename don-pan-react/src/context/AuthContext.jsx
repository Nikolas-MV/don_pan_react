import { createContext, useContext, useEffect, useMemo, useState } from 'react';
import { api, setCsrfToken } from '../services/api.js';

/**
 * Estado de autenticación en MEMORIA.
 *
 * Decisión de seguridad deliberada: la sesión real vive en la cookie HttpOnly
 * de PHP. En el navegador NO guardamos tokens ni datos sensibles en
 * localStorage/sessionStorage (blindado frente a XSS: un script malicioso no
 * puede leer lo que no está en JS). Sólo mantenemos el perfil visible
 * (nombre/rol) mientras la pestaña esté abierta.
 */

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [usuario, setUsuario] = useState(null);
  const [estado, setEstado] = useState('cargando'); // cargando | listo

  useEffect(() => {
    let vivo = true;

    async function comprobar() {
      try {
        const datos = await api.consultarSesion();
        if (!vivo) return;
        setCsrfToken(datos.csrf);
        setUsuario(datos.user);
      } catch {
        // Sin sesión o backend caído: seguimos como invitado.
        if (vivo) setUsuario(null);
      } finally {
        if (vivo) setEstado('listo');
      }
    }

    comprobar();
    return () => {
      vivo = false;
    };
  }, []);

  const valor = useMemo(
    () => ({
      usuario,
      estado,
      autenticado: Boolean(usuario),
      esDueno: usuario?.rol === 'dueño',
      async iniciarSesion(datos) {
        const respuesta = await api.iniciarSesion(datos);
        setCsrfToken(respuesta.csrf);
        setUsuario(respuesta.user);
        return respuesta.user;
      },
      async cerrarSesion() {
        try {
          await api.cerrarSesion();
        } finally {
          // Aunque falle la llamada, la sesión local siempre se limpia.
          setUsuario(null);
        }
      },
    }),
    [usuario, estado],
  );

  return <AuthContext.Provider value={valor}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const contexto = useContext(AuthContext);
  if (!contexto) {
    throw new Error('useAuth debe usarse dentro de <AuthProvider>');
  }
  return contexto;
}
