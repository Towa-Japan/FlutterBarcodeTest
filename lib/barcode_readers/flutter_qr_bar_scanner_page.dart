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
  final Size _scanSize = const Size(320, 200);
  Rect _scanRegion = Rect.zero;

  @override
  void initState() {
    super.initState();
    setState(() => _barcodeRead = false);
  }

  void _scanCode(Iterable<ScanResult> rslt) {
    if (!_barcodeRead) {
      final barcode = rslt.firstWhereOrNull(_isAccepted);
      if (barcode != null) {
        _barcodeRead = true;
        Navigator.pop(context, barcode.content);
      }
      setState(() => _scanResult = rslt);
    }
  }

  bool _isAccepted(ScanResult rslt) {
    final intersect = _scanRegion.intersect(rslt.bounds);
    return (intersect.width * intersect.height) /
            (rslt.bounds.width * rslt.bounds.height) >
        .75;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    _scanRegion = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 3),
      width: _scanSize.width,
      height: _scanSize.height,
    );

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Flutter QR Bar Scanner')),
        body: QRBarScannerCamera(
          formats: [BarcodeFormats.QR_CODE, BarcodeFormats.CODE_128],
          onError: (context, error) => Text(
            error.toString(),
            style: TextStyle(color: Colors.red),
          ),
          qrCodeCallback: _scanCode,
          child: Stack(
            children: [
              ...(_scanResult?.map((e) => Positioned(
                        left: e.bounds.left,
                        top: e.bounds.top,
                        child: Container(
                          height: e.bounds.height,
                          width: e.bounds.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  _isAccepted(e) ? Colors.green : Colors.orange,
                              width: 2,
                            ),
                          ),
                        ),
                      )) ??
                  Iterable.empty()),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  height: _scanRegion.top,
                  width: screenSize.width,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Positioned(
                left: 0,
                top: _scanRegion.bottom,
                child: Container(
                  height: screenSize.height - _scanRegion.bottom,
                  width: screenSize.width,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Positioned(
                left: 0,
                top: _scanRegion.top,
                child: Container(
                  height: _scanRegion.height,
                  width: _scanRegion.left,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Positioned(
                left: _scanRegion.right,
                top: _scanRegion.top,
                child: Container(
                  height: _scanRegion.height,
                  width: screenSize.width - _scanRegion.right,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Positioned(
                left: _scanRegion.left,
                top: _scanRegion.top,
                child: Container(
                  height: _scanRegion.height,
                  width: _scanRegion.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
