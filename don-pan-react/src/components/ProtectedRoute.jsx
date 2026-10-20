import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext.jsx';

/**
 * Guardia de rutas.
 * - Mientras carga la sesión → pantalla de carga (evita "parpadeo" a /login).
 * - Sin sesión → redirige al login guardando a dónde quería ir.
 * - Con `roles` exigidos → si el rol no coincide, vuelve al dashboard.
 *
 * NOTA: esto es control de acceso de INTERFAZ. La autorización real se aplica
 * también en el backend PHP (sesión + rol); esta capa sólo evita mostrar
 * pantallas a las que no puedes acceder.
 */
export default function ProtectedRoute({ roles, children }) {
  const { usuario, estado } = useAuth();
  const location = useLocation();

  if (estado === 'cargando') {
    return (
      <div className="loading-screen" role="status" aria-live="polite">
        <div className="spinner" />
        <p>Verificando sesión…</p>
      </div>
    );
  }

  if (!usuario) {
    // replace: no deja "volver" con el botón del navegador a la vista protegida.
    return <Navigate to="/" replace state={{ desde: location.pathname }} />;
  }

  if (roles && roles.length > 0 && !roles.includes(usuario.rol)) {
    return <Navigate to="/dashboard" replace state={{ restringido: true }} />;
  }

  return children;
}
