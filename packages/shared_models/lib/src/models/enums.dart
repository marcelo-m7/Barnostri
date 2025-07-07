enum OrderStatus {
  recebido('Recebido'),
  emPreparo('Em preparo'),
  pronto('Pronto'),
  entregue('Entregue'),
  cancelado('Cancelado');

  const OrderStatus(this.displayName);
  final String displayName;

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'Recebido':
        return OrderStatus.recebido;
      case 'Em preparo':
        return OrderStatus.emPreparo;
      case 'Pronto':
        return OrderStatus.pronto;
      case 'Entregue':
        return OrderStatus.entregue;
      case 'Cancelado':
        return OrderStatus.cancelado;
      default:
        return OrderStatus.recebido;
    }
  }
}

enum PaymentMethod {
  pix('Pix'),
  cartao('Cartão'),
  dinheiro('Dinheiro');

  const PaymentMethod(this.displayName);
  final String displayName;

  static PaymentMethod fromString(String method) {
    switch (method) {
      case 'Pix':
        return PaymentMethod.pix;
      case 'Cartão':
        return PaymentMethod.cartao;
      case 'Dinheiro':
        return PaymentMethod.dinheiro;
      default:
        return PaymentMethod.pix;
    }
  }
}
