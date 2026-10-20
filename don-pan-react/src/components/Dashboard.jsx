import React from 'react';
import { Link } from 'react-router-dom';

function Dashboard() {
  return (
    <div>
      <h1>📊 Panel Principal - Don Pan</h1>
      <p>Bienvenido, Don Oscar</p>
      
      {/* Menú de navegación básico para movernos entre pantallas */}
      <nav>
        <ul>
          <li><Link to="/productos">Productos</Link></li>
          <li><Link to="/ventas">Ventas</Link></li>
          <li><Link to="/inventario">Inventario</Link></li>
          <li><Link to="/clientes">Clientes</Link></li>
          <li><Link to="/reportes">Reportes</Link></li>
          <li><Link to="/">Cerrar Sesión</Link></li>
        </ul>
      </nav>
    </div>
  );
}

export default Dashboard;