import 'package:collection/collection.dart';
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
  Iterable<ScanResult>? _scanResult;

  @override
  void initState() {
    super.initState();
    setState(() => _barcodeRead = false);
  }

  void _scanCode(Iterable<ScanResult> rslt) {
    if (!_barcodeRead) {
      setState(() => _scanResult = rslt);
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
        body: GestureDetector(
          onTap: () {
            _barcodeRead = true;
            Navigator.pop(context, _scanResult?.firstOrNull?.content);
          },
          child: QRBarScannerCamera(
            formats: [BarcodeFormats.QR_CODE, BarcodeFormats.CODE_128],
            onError: (context, error) => Text(
              error.toString(),
              style: TextStyle(color: Colors.red),
            ),
            qrCodeCallback: _scanCode,
            child: Stack(
              children: (_scanResult?.map((e) => Positioned(
                            left: e.bounds.left,
                            top: e.bounds.top,
                            child: Container(
                              height: e.bounds.height,
                              width: e.bounds.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),
                          )) ??
                      Iterable.empty())
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
