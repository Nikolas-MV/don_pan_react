import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext.jsx';
import { api } from '../services/api.js';
import { Card, EmptyState, Kpi, PageHead } from '../components/ui.jsx';

const ACCESOS = [
  { ruta: '/ventas', icono: '💵', titulo: 'Registrar venta', desc: 'Cobro rápido y descuento de stock' },
  { ruta: '/productos', icono: '📦', titulo: 'Productos', desc: 'Precios, códigos y existencias' },
  { ruta: '/inventario', icono: '📋', titulo: 'Inventario', desc: 'Entradas de proveedor y alertas' },
  { ruta: '/clientes', icono: '👥', titulo: 'Clientes', desc: 'Frecuentes y datos de contacto' },
];

export default function Dashboard() {
  const { usuario, esDueno } = useAuth();
  const [resumen, setResumen] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    let vivo = true;
    api
      .obtenerResumen()
      .then((datos) => {
        if (vivo) setResumen(datos);
      })
      .catch((err) => {
        if (vivo) setError(err.message);
      });
    return () => {
      vivo = false;
    };
  }, []);

  const hora = new Date().getHours();
  const saludo = hora < 12 ? 'Buenos días' : hora < 19 ? 'Buenas tardes' : 'Buenas noches';

  return (
    <div className="stack">
      <PageHead
        emoji="📊"
        titulo={`${saludo}, ${usuario?.nombre?.split(' ')[0] ?? ''}`}
        subtitulo={
          resumen
            ? `Resumen operativo del ${new Date().toLocaleDateString('es-CO', {
                weekday: 'long',
                day: 'numeric',
                month: 'long',
              })}`
            : 'Cargando el resumen del día…'
        }
        acciones={
          esDueno ? (
            <Link className="btn btn--ghost" to="/reportes">
              📈 Ver reportes
            </Link>
          ) : null
        }
      />

      {error && (
        <p className="alert alert--info" role="status">
          No fue posible cargar el resumen: {error}
        </p>
      )}

      <section className="grid-kpi" aria-label="Indicadores">
        <Kpi icono="💵" valor={resumen ? resumen.ventasHoy : '—'} etiqueta="Ventas de hoy" tono="ok" />
        <Kpi icono="💰" valor={resumen ? resumen.totalHoy : '—'} etiqueta="Recaudo de hoy" tono="brand" />
        <Kpi icono="📦" valor={resumen ? resumen.productos : '—'} etiqueta="Productos activos" tono="info" />
        <Kpi
          icono="⚠️"
          valor={resumen ? resumen.stockBajo : '—'}
          etiqueta="Con stock bajo"
          tono={resumen && resumen.stockBajo > 0 ? 'warn' : 'info'}
        />
      </section>

      <Card titulo="Accesos rápidos">
        <div className="quick-links">
          {ACCESOS.map((item) => (
            <Link key={item.ruta} className="quick-link" to={item.ruta}>
              <span className="quick-link__icon" aria-hidden="true">
                {item.icono}
              </span>
              <span>
                <span className="quick-link__title">{item.titulo}</span>
                <span className="quick-link__desc">{item.desc}</span>
              </span>
            </Link>
          ))}
        </div>
      </Card>

      {!resumen && !error && (
        <EmptyState
          icono="⏳"
          titulo="Consultando la base de datos"
          texto="Si tarda más de unos segundos, verifica que MySQL esté corriendo en el panel de XAMPP."
        />
      )}
    </div>
  );
}
