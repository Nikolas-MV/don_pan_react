import { Component } from 'react';

/**
 * Límite de errores de React.
 * Sin él, una excepción durante el render deja la pantalla en blanco y el
 * usuario pierde toda la aplicación. Aquí se captura, se registra en consola
 * (sólo para desarrolladores) y se muestra un estado recuperable.
 */
export default class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { error: null };
  }

  static getDerivedStateFromError(error) {
    return { error };
  }

  componentDidCatch(error, info) {
    // En producción convendría enviar esto a un servicio de monitoreo.
    console.error('[Don Pan] Error de interfaz:', error, info?.componentStack);
  }

  render() {
    if (this.state.error) {
      return (
        <div className="loading-screen" role="alert">
          <span className="empty__icon" aria-hidden="true">
            ⚠️
          </span>
          <h2>Algo salió mal al pintar la pantalla</h2>
          <p className="muted" style={{ maxWidth: '46ch' }}>
            El error quedó registrado en la consola del navegador. Puedes
            reintentar sin perder la sesión.
          </p>
          <div className="row" style={{ justifyContent: 'center' }}>
            <button
              type="button"
              className="btn btn--primary"
              onClick={() => this.setState({ error: null })}
            >
              Reintentar
            </button>
            <a className="btn btn--ghost" href="/dashboard">
              Ir al panel
            </a>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
