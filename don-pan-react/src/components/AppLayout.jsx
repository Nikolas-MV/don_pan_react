import { useEffect, useState } from 'react';
import { NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext.jsx';

const MENU = [
  { ruta: '/dashboard', icono: '📊', etiqueta: 'Panel principal' },
  { ruta: '/productos', icono: '📦', etiqueta: 'Productos' },
  { ruta: '/ventas', icono: '💵', etiqueta: 'Ventas' },
  { ruta: '/inventario', icono: '📋', etiqueta: 'Inventario' },
  { ruta: '/clientes', icono: '👥', etiqueta: 'Clientes' },
  { ruta: '/reportes', icono: '📈', etiqueta: 'Reportes', soloDueno: true },
];

/**
 * Shell de la aplicación autenticada: barra lateral + contenido de la ruta.
 * El menú se dibuja UNA sola vez aquí (DRY) y se adapta a móvil con
 * "drawer" accesible (botón con aria-expanded + cierre con Escape).
 */
export default function AppLayout() {
  const { usuario, esDueno, cerrarSesion } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [abierto, setAbierto] = useState(false);

  // Al cambiar de ruta en móvil, el drawer se cierra solo.
  useEffect(() => {
    setAbierto(false);
  }, [location.pathname]);

  // Escape cierra el menú (accesibilidad).
  useEffect(() => {
    if (!abierto) return undefined;
    function alPulsar(e) {
      if (e.key === 'Escape') setAbierto(false);
    }
    window.addEventListener('keydown', alPulsar);
    return () => window.removeEventListener('keydown', alPulsar);
  }, [abierto]);

  async function salir() {
    await cerrarSesion();
    navigate('/', { replace: true });
  }

  const visibles = MENU.filter((item) => !item.soloDueno || esDueno);
  const titulos = Object.fromEntries(visibles.map((i) => [i.ruta, i.etiqueta]));
  const actual = titulos[location.pathname] ?? 'Don Pan';
  const iniciales = (usuario?.nombre ?? '?')
    .split(' ')
    .map((p) => p[0])
    .slice(0, 2)
    .join('')
    .toUpperCase();

  return (
    <div className="app-shell">
      <aside className={`sidebar${abierto ? ' open' : ''}`} id="menu-lateral">
        <div className="sidebar__brand">
          <span className="sidebar__logo" aria-hidden="true">
            🍞
          </span>
          <span>
            <span className="sidebar__name">Don Pan</span>
            <span className="sidebar__tag">Sistema de gestión</span>
          </span>
        </div>

        <nav aria-label="Navegación principal">
          <p className="sidebar__section">Operación</p>
          <div className="sidebar__nav">
            {visibles.map((item) => (
              <NavLink
                key={item.ruta}
                to={item.ruta}
                className={({ isActive }) => `nav-link${isActive ? ' active' : ''}`}
              >
                <span className="nav-link__icon" aria-hidden="true">
                  {item.icono}
                </span>
                {item.etiqueta}
              </NavLink>
            ))}
          </div>
        </nav>

        <div className="sidebar__footer">
          <div className="sidebar__user">
            <span className="sidebar__avatar" aria-hidden="true">
              {iniciales}
            </span>
            <span>
              <span className="sidebar__user-name">{usuario?.nombre}</span>
              <span className="sidebar__user-role">{usuario?.rol}</span>
            </span>
          </div>
          <button type="button" className="btn btn--danger btn--block" onClick={salir}>
            Cerrar sesión
          </button>
        </div>
      </aside>

      {abierto && (
        <button
          type="button"
          className="sidebar-overlay"
          aria-label="Cerrar menú"
          onClick={() => setAbierto(false)}
        />
      )}

      <div className="app-main">
        <header className="topbar">
          <button
            type="button"
            className="menu-btn"
            aria-expanded={abierto}
            aria-controls="menu-lateral"
            aria-label={abierto ? 'Cerrar menú' : 'Abrir menú'}
            onClick={() => setAbierto((v) => !v)}
          >
            ☰
          </button>
          <span className="topbar__title">{actual}</span>
        </header>

        <main className="content">
          <Outlet />
        </main>

        <footer className="app-footer">
          Panadería Don Pan · Sistema de gestión · Datos protegidos, uso interno
        </footer>
      </div>
    </div>
  );
}
