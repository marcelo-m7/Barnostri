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
  final Widget? overlay;
  const MobileScanner({
    super.key,
    this.controller,
    this.onDetect,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    onDetect?.call(const BarcodeCapture());
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        Center(child: Text(l10n.qrScanningNotSupportedOnWeb)),
        if (overlay != null) overlay!,
      ],
    );
  }
}
