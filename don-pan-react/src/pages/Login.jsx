import { useEffect, useRef, useState } from 'react';
import { Navigate, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext.jsx';

/**
 * Acceso real: POST /api/login.php con usuario + contraseña.
 * Protecciones aplicadas:
 *  - validación en cliente (mensajes claros) y en servidor (autoridad final),
 *  - mensaje de error GENÉRICO: no revela si el usuario existe (previene
 *    enumeración de cuentas),
 *  - autocomplete="username"/"current-password" para gestores de contraseñas,
 *  - estado de carga que bloquea dobles envíos,
 *  - sin almacenar nada en localStorage: la sesión vive en la cookie HttpOnly.
 */
export default function Login() {
  const { autenticado, estado, iniciarSesion } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const usuarioRef = useRef(null);

  const [usuario, setUsuario] = useState('');
  const [password, setPassword] = useState('');
  const [errores, setErrores] = useState({});
  const [errorServidor, setErrorServidor] = useState('');
  const [enviando, setEnviando] = useState(false);

  useEffect(() => {
    usuarioRef.current?.focus();
  }, []);

  if (estado === 'listo' && autenticado) {
    const destino = location.state?.desde ?? '/dashboard';
    return <Navigate to={destino} replace />;
  }

  function validar() {
    const nuevos = {};
    if (!usuario.trim()) nuevos.usuario = 'Escribe tu usuario.';
    if (!password) nuevos.password = 'Escribe tu contraseña.';
    setErrores(nuevos);
    return Object.keys(nuevos).length === 0;
  }

  async function alEnviar(e) {
    e.preventDefault();
    setErrorServidor('');
    if (enviando) return;
    if (!validar()) return;

    setEnviando(true);
    try {
      await iniciarSesion({ usuario: usuario.trim(), password });
      navigate(location.state?.desde ?? '/dashboard', { replace: true });
    } catch (err) {
      // Mensaje genérico: nunca decir "ese usuario no existe".
      const mensaje =
        err?.code === 'credenciales'
          ? 'Usuario o contraseña incorrectos.'
          : (err?.message ?? 'No se pudo iniciar sesión.');
      setErrorServidor(mensaje);
      setPassword('');
    } finally {
      setEnviando(false);
    }
  }

  return (
    <div className="login-screen">
      <aside className="login-aside">
        <div className="login-aside__brand">
          <span className="login-aside__logo" aria-hidden="true">
            🍞
          </span>
          Don Pan
        </div>

        <div>
          <h1 className="login-aside__title">Tu panadería, bajo control.</h1>
          <p className="login-aside__text">
            Ventas, inventario, clientes y reportes en un solo lugar. Menos
            cuadernos, mejores decisiones.
          </p>
          <ul className="login-aside__list">
            <li>Registro de ventas en segundos</li>
            <li>Alertas de stock bajo en tiempo real</li>
            <li>Reportes para el dueño y trazabilidad por turno</li>
          </ul>
        </div>

        <p className="login-aside__foot">
          Sistema de gestión · Acceso restringido a personal autorizado
        </p>
      </aside>

      <main className="login-main">
        <section className="login-card" aria-labelledby="titulo-login">
          <div className="login-card__head">
            <span className="login-card__emoji" aria-hidden="true">
              🥐
            </span>
            <h2 id="titulo-login">Iniciar sesión</h2>
            <p className="login-card__sub">Accede con tu cuenta de empleado</p>
          </div>

          <form className="form" onSubmit={alEnviar} noValidate>
            {errorServidor && (
              <p className="alert alert--error" role="alert">
                {errorServidor}
              </p>
            )}

            <div className="field">
              <label htmlFor="usuario">Usuario</label>
              <input
                ref={usuarioRef}
                id="usuario"
                name="usuario"
                className="input"
                type="text"
                autoComplete="username"
                autoCapitalize="none"
                spellCheck="false"
                maxLength={50}
                value={usuario}
                onChange={(e) => setUsuario(e.target.value)}
                aria-invalid={Boolean(errores.usuario)}
                aria-describedby={errores.usuario ? 'err-usuario' : undefined}
                disabled={enviando}
              />
              {errores.usuario && (
                <span className="field__error" id="err-usuario">
                  {errores.usuario}
                </span>
              )}
            </div>

            <div className="field">
              <label htmlFor="password">Contraseña</label>
              <input
                id="password"
                name="password"
                className="input"
                type="password"
                autoComplete="current-password"
                maxLength={72}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                aria-invalid={Boolean(errores.password)}
                aria-describedby={errores.password ? 'err-password' : undefined}
                disabled={enviando}
              />
              {errores.password && (
                <span className="field__error" id="err-password">
                  {errores.password}
                </span>
              )}
            </div>

            <button type="submit" className="btn btn--primary btn--block" disabled={enviando}>
              {enviando ? 'Verificando…' : 'Entrar'}
            </button>
          </form>

          <p className="login-hint">
            ¿Problemas para entrar? Pide el restablecimiento al administrador
            del sistema.
          </p>
        </section>
      </main>
    </div>
  );
}
