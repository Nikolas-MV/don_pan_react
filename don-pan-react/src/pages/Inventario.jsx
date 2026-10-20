import { Card, EmptyState, PageHead } from '../components/ui.jsx';

export default function Inventario() {
  return (
    <div className="stack">
      <PageHead
        emoji="📋"
        titulo="Inventario"
        subtitulo="Entradas de proveedor, salidas y alertas de reposicion"
      />
      <Card titulo="Movimientos">
        <EmptyState
          icono="📦"
          titulo="Sin movimientos registrados"
          texto="Las entradas de proveedor y los ajustes de stock quedaran aqui, con fecha, cantidad y motivo, para mantener la trazabilidad del inventario."
        />
      </Card>
      <Card titulo="Alertas de stock">
        <EmptyState
          icono="⚠️"
          titulo="Sin alertas activas"
          texto="Se avisara cuando un producto baje de su stock minimo configurado."
        />
      </Card>
    </div>
  );
}