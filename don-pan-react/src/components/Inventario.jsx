import React from 'react';
import { Link } from 'react-router-dom';

function Inventario() {
  return (
    <div>
      <h1>📋 Gestión de Inventario</h1>
      <p>Aquí se mostrará el stock y las alertas de productos bajos</p>
      <Link to="/dashboard">Volver al Dashboard</Link>
    </div>
  );
}

export default Inventario;