import React from 'react';
import { Link } from 'react-router-dom';

function Ventas() {
  return (
    <div>
      <h1>💵 Registro de Ventas</h1>
      <p>Aquí irá el carrito de compras y el cálculo del total</p>
      <Link to="/dashboard">Volver al Dashboard</Link>
    </div>
  );
}

export default Ventas;