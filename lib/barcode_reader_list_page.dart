import 'package:flutter/material.dart';
import 'package:flutter_barcode_test/barcode_reader_provider.dart';

class BarcodeReaderListPage extends StatefulWidget {
  BarcodeReaderListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _BarcodeReaderListPageState createState() => _BarcodeReaderListPageState();
}

class _BarcodeReaderListPageState extends State<BarcodeReaderListPage> {
  String? _barcodeText;
  Duration? _time;

  void _setBarcodeText(String? text, Duration? elapsed) {
    setState(() {
      _barcodeText = text;
      _time = elapsed;
    });
  }

  Widget _buildBarcodeContents(BuildContext context) {
    return Text(_barcodeText ?? '');
  }

  Widget _buildElapsedContents(BuildContext context) {
    return Text(_time?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    const readers = BarcodeReaderProvider();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
                child: Wrap(
                    direction: Axis.vertical,
                    spacing: 3,
                    children: readers
                        .getReaders()
                        .map((r) => TextButton(
                            onPressed: () => _run(() => r.value(context)),
                            child: Text(r.key)))
                        .toList())),
            _buildBarcodeContents(context),
            _buildElapsedContents(context),
          ],
        ),
      ),
    );
  }

  void _run(Future<String?> Function() readBarcode) async {
    final sw = new Stopwatch()..start();

    final bcText = await readBarcode();

    _setBarcodeText(bcText, sw.elapsed);
  }
}
