import { lazy, Suspense } from 'react';
import { BrowserRouter, Route, Routes } from 'react-router-dom';

import AppLayout from './components/AppLayout.jsx';
import ErrorBoundary from './components/ErrorBoundary.jsx';
import ProtectedRoute from './components/ProtectedRoute.jsx';
import { Loading } from './components/ui.jsx';
import Login from './pages/Login.jsx';

const Dashboard = lazy(() => import('./pages/Dashboard.jsx'));
const Productos = lazy(() => import('./pages/Productos.jsx'));
const Ventas = lazy(() => import('./pages/Ventas.jsx'));
const Inventario = lazy(() => import('./pages/Inventario.jsx'));
const Clientes = lazy(() => import('./pages/Clientes.jsx'));
const Reportes = lazy(() => import('./pages/Reportes.jsx'));
const NoEncontrada = lazy(() => import('./pages/NoEncontrada.jsx'));

// Nucleo del SPA.
// - Todas las rutas protegidas comparten AppLayout (sidebar + topbar) via
//   rutas anidadas: ProtectedRoute envuelve el LAYOUT, no cada pagina.
// - /reportes exige el rol dueño (misma regla que requireOwner() en PHP).
// - Carga diferida (lazy) para mantener pequeño el bundle inicial.
// - Ruta * con pagina 404 en vez de pantalla en blanco.
// Para servir el build bajo una subcarpeta usa VITE_BASE (ver .env.example).
const basename = (import.meta.env.VITE_BASE ?? '/').replace(/\/+$/, '') || '/';

export default function App() {
  return (
    <ErrorBoundary>
      <BrowserRouter basename={basename}>
        <Suspense fallback={<Loading />}>
          <Routes>
            <Route path="/" element={<Login />} />

            <Route
              element={
                <ProtectedRoute>
                  <AppLayout />
                </ProtectedRoute>
              }
            >
              <Route path="/dashboard" element={<Dashboard />} />
              <Route path="/productos" element={<Productos />} />
              <Route path="/ventas" element={<Ventas />} />
              <Route path="/inventario" element={<Inventario />} />
              <Route path="/clientes" element={<Clientes />} />
              <Route
                path="/reportes"
                element={
                  <ProtectedRoute roles={['dueño']}>
                    <Reportes />
                  </ProtectedRoute>
                }
              />
            </Route>

            <Route path="*" element={<NoEncontrada />} />
          </Routes>
        </Suspense>
      </BrowserRouter>
    </ErrorBoundary>
  );
}