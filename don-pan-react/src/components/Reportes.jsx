import React from 'react';
import { Link } from 'react-router-dom';

function Reportes() {
  return (
    <div>
      <h1>📈 Generación de Reportes</h1>
      <p>Aquí se mostrarán las ventas del día y el producto más vendido</p>
      <Link to="/dashboard">Volver al Dashboard</Link>
    </div>
  );
}

export default Reportes;