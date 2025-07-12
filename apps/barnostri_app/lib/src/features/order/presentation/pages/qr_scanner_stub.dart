import 'package:flutter/widgets.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';

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
  final QrScannerOverlayShape? overlay;
  const QRView({super.key, this.onQRViewCreated, this.overlay});

  @override
  Widget build(BuildContext context) {
    // Notify that scanning is not available on web
    onQRViewCreated?.call(const QRViewController());
    final l10n = AppLocalizations.of(context);
    return Center(child: Text(l10n.qrScanningNotSupportedOnWeb));
  }
}

/// Stub implementation of [QrScannerOverlayShape] for web where scanning
/// is not supported. It simply draws nothing but allows the app to compile.
class QrScannerOverlayShape extends ShapeBorder {
  const QrScannerOverlayShape({
    this.borderColor = const Color(0x00000000),
    this.borderWidth = 0,
    this.overlayColor = const Color(0x00000000),
    this.borderRadius = 0,
    this.borderLength = 0,
    double? cutOutSize,
    double? cutOutWidth,
    double? cutOutHeight,
    this.cutOutBottomOffset = 0,
  })  : cutOutWidth = cutOutWidth ?? cutOutSize ?? 0,
        cutOutHeight = cutOutHeight ?? cutOutSize ?? 0;

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
