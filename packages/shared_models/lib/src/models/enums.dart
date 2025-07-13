enum OrderStatus {
  received('Received'),
  preparing('Preparing'),
  ready('Ready'),
  delivered('Delivered'),
  canceled('Canceled');

  const OrderStatus(this.displayName);
  final String displayName;

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'Received':
      case 'Recebido':
        return OrderStatus.received;
      case 'Preparing':
      case 'Em preparo':
        return OrderStatus.preparing;
      case 'Ready':
      case 'Pronto':
        return OrderStatus.ready;
      case 'Delivered':
      case 'Entregue':
        return OrderStatus.delivered;
      case 'Canceled':
      case 'Cancelado':
        return OrderStatus.canceled;
      default:
        return OrderStatus.received;
    }
  }
}

enum PaymentMethod {
  pix('Pix'),
  card('Card'),
  cash('Cash');

  const PaymentMethod(this.displayName);
  final String displayName;

  static PaymentMethod fromString(String method) {
    switch (method) {
      case 'Pix':
        return PaymentMethod.pix;
      case 'Card':
      case 'Cartão':
      case 'Cartao':
        return PaymentMethod.card;
      case 'Cash':
      case 'Dinheiro':
        return PaymentMethod.cash;
      default:
        return PaymentMethod.pix;
    }
  }
}

enum UserType {
  cliente('cliente'),
  lojista('lojista');

  const UserType(this.value);
  final String value;

  static UserType fromString(String type) {
    switch (type) {
      case 'lojista':
        return UserType.lojista;
      case 'cliente':
      default:
        return UserType.cliente;
    }
  }

  @override
  String toString() => value;
}
