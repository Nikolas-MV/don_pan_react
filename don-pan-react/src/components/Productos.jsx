import React from 'react';
import { Link } from 'react-router-dom';

function Productos() {
  return (
    <div>
      <h1>📦 Gestión de Productos</h1>
      <p>Aquí irá la tabla de productos (Pan Francés, Pastel, etc.)</p>
      <Link to="/dashboard">Volver al Dashboard</Link>
    </div>
  );
}

export default Productos;