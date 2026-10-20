import { Link } from 'react-router-dom';
import { EmptyState } from '../components/ui.jsx';

export default function NoEncontrada() {
  return (
    <div className="loading-screen">
      <EmptyState
        icono="🧭"
        titulo="Pagina no encontrada"
        texto="La direccion que intentas abrir no existe en este sistema."
      >
        <Link className="btn btn--primary" to="/dashboard">
          Ir al panel
        </Link>
      </EmptyState>
    </div>
  );
}