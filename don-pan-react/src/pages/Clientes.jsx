import { Card, EmptyState, PageHead } from '../components/ui.jsx';

export default function Clientes() {
  return (
    <div className="stack">
      <PageHead
        emoji="👥"
        titulo="Clientes"
        subtitulo="Clientes frecuentes y datos de contacto"
      />
      <Card titulo="Directorio">
        <EmptyState
          icono="🧑‍🍳"
          titulo="Todavia sin clientes registrados"
          texto="Al registrar un cliente aparecera aqui su nombre, telefono e historial de compras asociadas."
        />
      </Card>
    </div>
  );
}