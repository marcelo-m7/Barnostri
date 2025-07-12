// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;

import 'qr_scanner_stub.dart' as stub;

export 'qr_scanner_stub.dart' show Barcode, BarcodeCapture;

typedef BarcodeCaptureCallback = void Function(stub.BarcodeCapture capture);

class MobileScannerController {
  qr.QRViewController? _controller;
  final _streamController =
      StreamController<stub.BarcodeCapture>.broadcast();

  Stream<stub.BarcodeCapture> get barcodes => _streamController.stream;

  void _attach(qr.QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((barcode) {
      _streamController.add(
        stub.BarcodeCapture(
          barcodes: [stub.Barcode(rawValue: barcode.code)],
        ),
      );
    });
  }

  Future<void> start() async {
    await _controller?.resumeCamera();
  }

  Future<void> stop() async {
    await _controller?.stopCamera();
  }

  Future<void> pause() async {
    await _controller?.pauseCamera();
  }

  void dispose() {
    _controller?.dispose();
    _streamController.close();
  }
}

class MobileScanner extends StatefulWidget {
  final MobileScannerController? controller;
  final BarcodeCaptureCallback? onDetect;
  final Widget? overlay;

  const MobileScanner({super.key, this.controller, this.onDetect, this.overlay});

  @override
  State<MobileScanner> createState() => _MobileScannerState();
}

class _MobileScannerState extends State<MobileScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'qr');
  late MobileScannerController controller;
  bool? supported;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? MobileScannerController();
    _checkSupport();
  }

  Future<void> _checkSupport() async {
    try {
      final devices =
          await html.window.navigator.mediaDevices?.enumerateDevices();
      supported = devices?.any((e) => e.kind == 'videoinput') ?? false;
    } catch (_) {
      supported = false;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (supported == null) {
      return const SizedBox();
    }
    if (supported == false) {
      return stub.MobileScanner(
        controller: const stub.MobileScannerController(),
        onDetect: widget.onDetect,
        overlay: widget.overlay,
      );
    }
    return Stack(
      children: [
        qr.QRView(
          key: qrKey,
          onQRViewCreated: (c) {
            controller._attach(c);
            controller.barcodes.listen((capture) {
              widget.onDetect?.call(capture);
            });
          },
        ),
        if (widget.overlay != null) widget.overlay!,
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
