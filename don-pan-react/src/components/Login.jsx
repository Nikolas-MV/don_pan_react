import React from 'react';
import { Link } from 'react-router-dom';

function Login() {
  return (
    <div>
      <h1>🍞 Iniciar Sesión - Don Pan</h1>
      <p>Pantalla de Login (En construcción)</p>
      {/* Un botón para simular que entramos al sistema */}
      <Link to="/dashboard">
        <button>Ingresar al Sistema</button>
      </Link>
    </div>
  );
}

export default Login;