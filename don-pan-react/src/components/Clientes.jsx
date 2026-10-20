import React from 'react';
import { Link } from 'react-router-dom';

function Clientes() {
  return (
    <div>
      <h1>👤 Gestión de Clientes</h1>
      <p>Aquí irá la lista de clientes frecuentes y sus puntos</p>
      <Link to="/dashboard">Volver al Dashboard</Link>
    </div>
  );
}

export default Clientes;