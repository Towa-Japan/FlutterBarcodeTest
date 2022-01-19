import 'package:flutter/material.dart';

import 'barcode_readers/bluetooth_barcode_scanner_page.dart';
import 'barcode_readers/fast_barcode_scanner_page.dart';
import 'barcode_readers/flutter_barcode_scanner.dart';
import 'barcode_readers/flutter_qr_bar_scanner_page.dart';
import 'barcode_readers/qr_code_scanner_page.dart';

class BarcodeReaderProvider {
  const BarcodeReaderProvider();

  Iterable<MapEntry<String, Future<String?> Function(BuildContext context)>>
      getReaders() {
    return {
      'flutter': (context) => scanBarcodeWithFlutterBarcodeScanner(),
      'fast': (context) => _readWithFastBarcode(context),
      'QR Bar': (context) => _readWithQRBarScanner(context),
      'QR code': (context) => _readWithQrCodeScanner(context),
      'keyboard': (context) => _readWithBluetoothReader(context)
    }.entries;
  }

  Future<String?> _readWithFastBarcode(BuildContext context) async {
    return Navigator.of(context)
        .push<String?>(MaterialPageRoute(builder: (context) {
      return const FastBarcodeScannerPage();
    }));
  }

  Future<String?> _readWithQRBarScanner(BuildContext context) async {
    return Navigator.of(context)
        .push<String?>(MaterialPageRoute(builder: (context) {
      return const FlutterQrBarScannerPage();
    }));
  }

  Future<String?> _readWithQrCodeScanner(BuildContext context) async {
    return Navigator.of(context)
        .push<String?>(MaterialPageRoute(builder: (context) {
      return const QrCodeScannerPage();
    }));
  }

  Future<String?> _readWithBluetoothReader(BuildContext context) async {
    return Navigator.of(context)
        .push<String?>(MaterialPageRoute(builder: (context) {
      return const BluetoothBarcodeScannerPage();
    }));
  }
}
