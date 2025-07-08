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
        return OrderStatus.received;
      case 'Preparing':
        return OrderStatus.preparing;
      case 'Ready':
        return OrderStatus.ready;
      case 'Delivered':
        return OrderStatus.delivered;
      case 'Canceled':
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
        return PaymentMethod.card;
      case 'Cash':
        return PaymentMethod.cash;
      default:
        return PaymentMethod.pix;
    }
  }
}
