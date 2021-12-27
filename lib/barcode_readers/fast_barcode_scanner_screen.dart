import 'package:flutter/material.dart';
import 'package:fast_barcode_scanner/fast_barcode_scanner.dart';

class FastBarcodeScannerScreen extends StatelessWidget {
  const FastBarcodeScannerScreen();

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
    return Scaffold(
        appBar: AppBar(title: Text('Barcode Scanner')),
        body: BarcodeCamera(
          types: const [BarcodeType.code128, BarcodeType.qr],
          resolution: Resolution.hd720,
          framerate: Framerate.fps60,
          mode: DetectionMode.pauseVideo,
          onScan: (code) => Navigator.pop(context, code.value),
          children: [
            MaterialPreviewOverlay(animateDetection: false),
          ],
        ));
  }
}
