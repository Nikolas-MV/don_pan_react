import { useEffect, useMemo, useState } from 'react';
import { api } from '../services/api.js';
import { Card, EmptyState, Loading, PageHead } from '../components/ui.jsx';

/**
 * Listado real de productos desde /api/productos.php (solo lectura).
 * La busqueda es local: con los conjuntos de una panaderia es instantanea y
 * no genera un viaje extra al servidor.
 */
export default function Productos() {
  const [productos, setProductos] = useState(null);
  const [busqueda, setBusqueda] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    let vivo = true;
    api
      .listarProductos()
      .then((datos) => {
        if (vivo) setProductos(datos.productos);
      })
      .catch((err) => {
        if (vivo) setError(err.message);
      });
    return () => {
      vivo = false;
    };
  }, []);

  const filtrados = useMemo(() => {
    if (!productos) return [];
    const q = busqueda.trim().toLowerCase();
    if (!q) return productos;
    return productos.filter(
      (p) =>
        p.nombre.toLowerCase().includes(q) ||
        (p.codigo_barra ?? '').toLowerCase().includes(q),
    );
  }, [productos, busqueda]);

  return (
    <div className="stack">
      <PageHead
        emoji="📦"
        titulo="Productos"
        subtitulo="Catalogo con precios y existencias en tiempo real"
        acciones={
          <input
            className="input"
            type="search"
            placeholder="Buscar por nombre o codigo..."
            aria-label="Buscar productos"
            value={busqueda}
            onChange={(e) => setBusqueda(e.target.value)}
            style={{ minWidth: '260px' }}
          />
        }
      />

      <Card
        titulo={`Catalogo (${productos ? filtrados.length : '...'})`}
        acciones={
          <span className="muted" style={{ fontSize: 'var(--dp-fs-xs)' }}>
            Fuente: MariaDB - tabla productos
          </span>
        }
      >
        {error && <p className="alert alert--error">{error}</p>}

        {!productos && !error && <Loading texto="Cargando productos..." />}

        {productos && productos.length === 0 && (
          <EmptyState
            icono="🥖"
            titulo="Aun no hay productos registrados"
            texto="Crea el primer producto desde la aplicacion PHP (modulo Inventario) y aparecera aqui automaticamente."
          />
        )}

        {productos && productos.length > 0 && filtrados.length === 0 && (
          <EmptyState
            icono="🔍"
            titulo="Sin coincidencias"
            texto={'Ningun producto coincide con "' + busqueda + '".'}
          />
        )}

        {filtrados.length > 0 && (
          <div className="table-wrap">
            <table className="table">
              <thead>
                <tr>
                  <th scope="col">Producto</th>
                  <th scope="col">Codigo</th>
                  <th scope="col" className="table__num">Precio</th>
                  <th scope="col" className="table__num">Stock</th>
                  <th scope="col">Estado</th>
                </tr>
              </thead>
              <tbody>
                {filtrados.map((p) => {
                  const bajo = p.stock_actual <= p.stock_minimo;
                  return (
                    <tr key={p.id_producto}>
                      <td>{p.nombre}</td>
                      <td className="muted">{p.codigo_barra || '-'}</td>
                      <td className="table__num">${Number(p.precio).toFixed(2)}</td>
                      <td className="table__num">{p.stock_actual}</td>
                      <td>
                        <span className={`badge badge--${bajo ? 'warn' : 'ok'}`}>
                          {bajo ? 'Stock bajo' : 'Disponible'}
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
      </Card>
    </div>
  );
}
