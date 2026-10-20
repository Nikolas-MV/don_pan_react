import { useAuth } from '../context/AuthContext.jsx';
import { Badge, Card, EmptyState, PageHead } from '../components/ui.jsx';

export default function Reportes() {
  const { usuario } = useAuth();

  return (
    <div className="stack">
      <PageHead
        emoji="📈"
        titulo="Reportes"
        subtitulo="Indicadores para la toma de decisiones"
        acciones={<Badge tono="owner">Acceso: dueño</Badge>}
      />

      <Card titulo="Informacion restringida">
        <EmptyState
          icono="🔐"
          titulo={'Solo el rol "dueño" puede ver estos datos'}
          texto={
            'Este modulo esta protegido en dos capas: la interfaz (ProtectedRoute) y el backend (requireOwner() en PHP). La sesion actual es de ' +
            (usuario?.nombre ?? 'un usuario') +
            ' con rol "' +
            (usuario?.rol ?? '') +
            '".'
          }
        />
      </Card>
    </div>
  );
}