import 'package:flutter/material.dart';
import 'package:flutter_qr_bar_scanner/flutter_qr_bar_scanner.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:flutter_qr_bar_scanner/scan_result.dart';

class FlutterQrBarScannerPage extends StatefulWidget {
  const FlutterQrBarScannerPage();

  _FlutterQrBarScannerPageState createState() =>
      _FlutterQrBarScannerPageState();
}

class _FlutterQrBarScannerPageState extends State<FlutterQrBarScannerPage> {
  bool _barcodeRead = false;

  @override
  void initState() {
    super.initState();
    setState(() => _barcodeRead = false);
  }

  void _scanCode(ScanResult rslt) {
    if (!_barcodeRead) {
      setState(() => _barcodeRead = true);
      Navigator.pop(context, rslt.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(title: Text('Flutter QR Bar Scanner')),
          body: Center(
            child: SizedBox(
              height: 1000,
              width: 500,
              child: QRBarScannerCamera(
                  formats: [BarcodeFormats.QR_CODE, BarcodeFormats.CODE_128],
                  onError: (context, error) => Text(
                        error.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                  qrCodeCallback: _scanCode),
            ),
          ),
        ));
  }
}
