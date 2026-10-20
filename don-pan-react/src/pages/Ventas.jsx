import { Card, EmptyState, PageHead } from '../components/ui.jsx';

export default function Ventas() {
  return (
    <div className="stack">
      <PageHead
        emoji="💵"
        titulo="Ventas"
        subtitulo="Registro de cobros con descuento automatico de stock"
      />
      <Card titulo="Sesion de venta">
        <EmptyState
          icono="🧾"
          titulo="Carrito de compras proximamente"
          texto="Aqui se listaran los productos seleccionados, el total y el boton de cobro. Cada venta descontara el stock en una transaccion atomica (ver actions/venta_action.php en la aplicacion PHP)."
        >
          <a className="btn btn--ghost" href="/dashboard">
            Volver al panel
          </a>
        </EmptyState>
      </Card>
    </div>
  );
}