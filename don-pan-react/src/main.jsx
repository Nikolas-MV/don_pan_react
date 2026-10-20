import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';

import App from './App.jsx';
import { AuthProvider } from './context/AuthContext.jsx';

// Hoja de estilos global en orden: tokens -> base -> layout -> componentes
import './styles/tokens.css';
import './styles/global.css';
import './styles/layout.css';
import './styles/components.css';
import './styles/forms.css';
import './styles/login.css';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <AuthProvider>
      <App />
    </AuthProvider>
  </StrictMode>,
);