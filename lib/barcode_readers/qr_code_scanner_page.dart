import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage();

  @override
  State<StatefulWidget> createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'scanner');

  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: _buildScanScreen(context),
    );
  }

  Widget _buildScanScreen(BuildContext context) {
    final scanArea = MediaQuery.of(context).size.width * .8;
    return Scaffold(
        appBar: AppBar(title: Text('Barcode Scanner')),
        body: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutWidth: scanArea,
              cutOutHeight: scanArea / 2),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          formatsAllowed: [BarcodeFormat.code128, BarcodeFormat.qrcode],
        ));
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller
          .stopCamera()
          .whenComplete(() => Navigator.pop(context, scanData.code));
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
