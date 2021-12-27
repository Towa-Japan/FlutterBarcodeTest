import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future<String> scanBarcodeWithFlutterBarcodeScanner() async {
  final _scanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', 'キャンセル', true, ScanMode.BARCODE);
  return _scanRes;
}
