/**
 * Piezas visuales compartidas por todas las páginas.
 * Mantenerlas aquí garantiza consistencia (misma sombra, mismo radio, mismos
 * espaciados) y evita duplicar JSX en cada vista.
 */

export function PageHead({ emoji, titulo, subtitulo, acciones }) {
  return (
    <header className="page-head">
      <div>
        <div className="page-head__title">
          <span className="page-head__emoji" aria-hidden="true">
            {emoji}
          </span>
          <h1>{titulo}</h1>
        </div>
        {subtitulo && <p className="page-head__sub">{subtitulo}</p>}
      </div>
      {acciones && <div className="row">{acciones}</div>}
    </header>
  );
}

export function Card({ titulo, acciones, children }) {
  return (
    <section className="card">
      {(titulo || acciones) && (
        <div className="card__head">
          {titulo && <h2 className="card__title">{titulo}</h2>}
          {acciones}
        </div>
      )}
      <div className="card__body">{children}</div>
    </section>
  );
}

export function Kpi({ icono, valor, etiqueta, tono = 'brand' }) {
  return (
    <article className="kpi">
      <span className={`kpi__icon kpi__icon--${tono}`} aria-hidden="true">
        {icono}
      </span>
      <div>
        <p className="kpi__value">{valor}</p>
        <p className="kpi__label">{etiqueta}</p>
      </div>
    </article>
  );
}

export function EmptyState({ icono, titulo, texto, children }) {
  return (
    <div className="empty">
      <span className="empty__icon" aria-hidden="true">
        {icono}
      </span>
      <p className="empty__title">{titulo}</p>
      {texto && <p className="empty__text">{texto}</p>}
      {children}
    </div>
  );
}

export function Loading({ texto = 'Cargando…' }) {
  return (
    <div className="loading-screen" role="status" aria-live="polite">
      <div className="spinner" />
      <p>{texto}</p>
    </div>
  );
}

export function Badge({ tono = 'off', children }) {
  return <span className={`badge badge--${tono}`}>{children}</span>;
}
