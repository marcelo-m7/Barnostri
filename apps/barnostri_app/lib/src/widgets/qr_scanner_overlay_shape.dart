import 'package:flutter/widgets.dart';

/// Stub implementation of [QrScannerOverlayShape] for platforms where scanning
/// is not supported or when a simple transparent overlay is sufficient. The
/// shape doesn't draw anything but keeps the API consistent across targets.
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
