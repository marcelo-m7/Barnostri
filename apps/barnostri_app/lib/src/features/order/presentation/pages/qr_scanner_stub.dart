import 'package:flutter/widgets.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';

class Barcode {
  final String? rawValue;
  const Barcode({this.rawValue});
}

class BarcodeCapture {
  final List<Barcode> barcodes;
  const BarcodeCapture({this.barcodes = const []});
}

class MobileScannerController {
  const MobileScannerController();
  Stream<BarcodeCapture> get barcodes => const Stream.empty();
  Future<void> start() async {}
  Future<void> stop() async {}
  Future<void> pause() async {}
  void dispose() {}
}

typedef BarcodeCaptureCallback = void Function(BarcodeCapture capture);

class MobileScanner extends StatelessWidget {
  final MobileScannerController? controller;
  final BarcodeCaptureCallback? onDetect;
  final LayoutWidgetBuilder? overlayBuilder;
  const MobileScanner({
    super.key,
    this.controller,
    this.onDetect,
    this.overlayBuilder,
  });

  @override
  Widget build(BuildContext context) {
    onDetect?.call(const BarcodeCapture());
    final l10n = AppLocalizations.of(context);
    final overlay = overlayBuilder?.call(context, const BoxConstraints());
    return Stack(
      children: [
        Center(child: Text(l10n.qrScanningNotSupportedOnWeb)),
        if (overlay != null) overlay,
      ],
    );
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
