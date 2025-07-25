// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:core';
import 'dart:html' as html;
import 'dart:js_util';
import 'dart:ui_web' as ui; // ignore: uri_does_not_exist
import 'dart:ui' show Size;

import 'package:flutter/material.dart';

import '../../qr_code_scanner.dart';
import 'jsqr.dart';
import 'media.dart';

/// Even though it has been highly modified, the origial implementation has been
/// adopted from https://github.com:treeder/jsqr_flutter
///
/// Copyright 2020 @treeder
/// Copyright 2021 The one with the braid

class WebQrView extends StatefulWidget {
  final QRViewCreatedCallback onPlatformViewCreated;
  final PermissionSetCallback? onPermissionSet;
  final CameraFacing? cameraFacing;

  const WebQrView(
      {Key? key,
      required this.onPlatformViewCreated,
      this.onPermissionSet,
      this.cameraFacing = CameraFacing.front})
      : super(key: key);

  @override
  _WebQrViewState createState() => _WebQrViewState();

  static html.DivElement vidDiv =
      html.DivElement(); // need a global for the registerViewFactory

  static Future<bool> cameraAvailable() async {
    final sources =
        await html.window.navigator.mediaDevices!.enumerateDevices();
    // List<String> vidIds = [];
    var hasCam = false;
    for (final e in sources) {
      if (e.kind == 'videoinput') {
        // vidIds.add(e['deviceId']);
        hasCam = true;
      }
    }
    return hasCam;
  }
}

class _WebQrViewState extends State<WebQrView> {
  html.MediaStream? _localStream;
  // html.CanvasElement canvas;
  // html.CanvasRenderingContext2D ctx;
  bool _currentlyProcessing = false;

  QRViewControllerWeb? _controller;

  late Size _size = const Size(0, 0);
  String? code;
  String? _errorMsg;
  html.VideoElement video = html.VideoElement();
  String viewID = 'QRVIEW-' + DateTime.now().millisecondsSinceEpoch.toString();

  final StreamController<Barcode> _scanUpdateController =
      StreamController<Barcode>();
  late CameraFacing facing;

  Timer? _frameIntervall;

  @visibleForTesting
  Timer? get frameInterval => _frameIntervall;

  @visibleForTesting
  set frameInterval(Timer? timer) => _frameIntervall = timer;

  @override
  void initState() {
    super.initState();

    facing = widget.cameraFacing ?? CameraFacing.front;

    // video = html.VideoElement();
    WebQrView.vidDiv.children = [video];
    // ignore: UNDEFINED_PREFIXED_NAME
    ui.platformViewRegistry
        .registerViewFactory(viewID, (int id) => WebQrView.vidDiv);
    // giving JavaScipt some time to process the DOM changes
    Timer(const Duration(milliseconds: 500), () {
      start();
    });
  }

  Future start() async {
    await _makeCall();
    _frameIntervall?.cancel();
    _frameIntervall =
        Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _captureFrame2();
    });
  }

  void cancel() {
    _frameIntervall?.cancel();
    _frameIntervall = null;
    if (_currentlyProcessing) {
      _stopStream();
    }
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _makeCall() async {
    if (_localStream != null) {
      return;
    }

    try {
      var constraints = UserMediaOptions(
          video: VideoOptions(
        facingMode: (facing == CameraFacing.front ? 'user' : 'environment'),
      ));
      // dart style, not working properly:
      // var stream =
      //     await html.window.navigator.mediaDevices.getUserMedia(constraints);
      // straight JS:
      if (_controller == null) {
        _controller = QRViewControllerWeb(this);
        widget.onPlatformViewCreated(_controller!);
      }
      var stream = await promiseToFuture(getUserMedia(constraints));
      widget.onPermissionSet?.call(_controller!, true);
      _localStream = stream;
      video.srcObject = _localStream;
      video.setAttribute('playsinline',
          'true'); // required to tell iOS safari we don't want fullscreen
      await video.play();
    } catch (e) {
      cancel();
      if (e.toString().contains("NotAllowedError")) {
        widget.onPermissionSet?.call(_controller!, false);
      }
      setState(() {
        _errorMsg = e.toString();
      });
      return;
    }
    if (!mounted) return;

    setState(() {
      _currentlyProcessing = true;
    });
  }

  Future<void> _stopStream() async {
    try {
      // await _localStream.dispose();
      _localStream!.getTracks().forEach((track) {
        if (track.readyState == 'live') {
          track.stop();
        }
      });
      // video.stop();
      video.srcObject = null;
      _localStream = null;
      // _localRenderer.srcObject = null;
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<dynamic> _captureFrame2() async {
    if (_localStream == null) {
      return null;
    }
    final canvas =
        html.CanvasElement(width: video.videoWidth, height: video.videoHeight);
    final ctx = canvas.context2D;
    // canvas.width = video.videoWidth;
    // canvas.height = video.videoHeight;
    ctx.drawImage(video, 0, 0);
    final imgData = ctx.getImageData(0, 0, canvas.width!, canvas.height!);

    final size =
        Size(canvas.width?.toDouble() ?? 0, canvas.height?.toDouble() ?? 0);
    if (size != _size) {
      setState(() {
        _setCanvasSize(size);
      });
    }

    final code = jsQR(imgData.data, canvas.width, canvas.height);
    // ignore: unnecessary_null_comparison
    if (code != null) {
      _scanUpdateController
          .add(Barcode(code.data, BarcodeFormat.qrcode, code.data.codeUnits));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMsg != null) {
      return Center(child: Text(_errorMsg!));
    }
    if (_localStream == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        var zoom = 1.0;

        if (_size.height != 0) zoom = constraints.maxHeight / _size.height;

        if (_size.width != 0) {
          final horizontalZoom = constraints.maxWidth / _size.width;
          if (horizontalZoom > zoom) {
            zoom = horizontalZoom;
          }
        }

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Center(
            child: SizedBox.fromSize(
              size: _size,
              child: Transform.scale(
                alignment: Alignment.center,
                scale: zoom,
                child: HtmlElementView(viewType: viewID),
              ),
            ),
          ),
        );
      },
    );
  }

  void _setCanvasSize(Size size) {
    setState(() {
      _size = size;
    });
  }
}

class QRViewControllerWeb implements QRViewController {
  final _WebQrViewState _state;

  QRViewControllerWeb(this._state);

  @override
  void dispose() => _state.cancel();

  @override
  Future<CameraFacing> flipCamera() async {
    _state.facing = _state.facing == CameraFacing.front
        ? CameraFacing.back
        : CameraFacing.front;
    await _state.start();
    return _state.facing;
  }

  @override
  Future<CameraFacing> getCameraInfo() async {
    return _state.facing;
  }

  @override
  Future<bool?> getFlashStatus() async {
    // Flash is not currently supported on web
    return false;
  }

  @override
  Future<SystemFeatures> getSystemFeatures() async {
    try {
      final devices =
          await html.window.navigator.mediaDevices?.enumerateDevices();
      final cameras =
          devices?.where((e) => e.kind == 'videoinput').toList() ?? <dynamic>[];
      final hasBack = cameras.isNotEmpty;
      final hasFront = cameras.length > 1;
      return SystemFeatures(false, hasBack, hasFront);
    } catch (_) {
      return SystemFeatures(false, false, false);
    }
  }

  @override
  bool get hasPermissions => _state._localStream != null;

  @override
  Future<void> pauseCamera() async {
    _state._frameIntervall?.cancel();
    _state.video.pause();
  }

  @override
  Future<void> resumeCamera() async {
    await _state.start();
  }

  @override
  Stream<Barcode> get scannedDataStream => _state._scanUpdateController.stream;

  @override
  Future<void> stopCamera() async {
    _state._frameIntervall?.cancel();
    _state._frameIntervall = null;
    await _state._stopStream();
  }

  @override
  Future<void> toggleFlash() async {
    // Flash is not currently supported on web
    return;
  }

  @override
  Future<void> scanInvert(bool isScanInvert) async {
    // Inverted scanning is not supported on web
    return;
  }
}

Widget createWebQrView(
        {onPlatformViewCreated, onPermissionSet, CameraFacing? cameraFacing}) =>
    WebQrView(
      onPlatformViewCreated: onPlatformViewCreated,
      onPermissionSet: onPermissionSet,
      cameraFacing: cameraFacing,
    );
