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

/// Fallback implementation used when QR scanning isn't available (e.g. web).
/// This simply defines the same API as [QrScannerOverlayShape] from the
/// `qr_code_scanner` package so that the rest of the code can compile on web.
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = const Color(0x00000000),
    this.borderWidth = 0,
    this.overlayColor = const Color(0x00000000),
    this.borderRadius = 0,
    this.borderLength = 0,
    this.cutOutSize = 0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()..addRect(rect);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path()..addRect(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
