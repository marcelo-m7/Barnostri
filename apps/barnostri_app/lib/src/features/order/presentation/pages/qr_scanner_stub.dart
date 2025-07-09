import 'package:flutter/widgets.dart';

class Barcode {
  final String? code;
  const Barcode(this.code);
}

class QRViewController {
  const QRViewController();
  Stream<Barcode> get scannedDataStream => const Stream.empty();
  void pauseCamera() {}
  void resumeCamera() {}
  void dispose() {}
}

typedef QRViewCreatedCallback = void Function(QRViewController controller);

class QRView extends StatelessWidget {
  final QRViewCreatedCallback? onQRViewCreated;
  final Widget? overlay;
  const QRView({super.key, this.onQRViewCreated, this.overlay});

  @override
  Widget build(BuildContext context) {
    // Notify that scanning is not available on web
    onQRViewCreated?.call(const QRViewController());
    return Center(child: Text('QR scanning not supported on web'));
  }
}
