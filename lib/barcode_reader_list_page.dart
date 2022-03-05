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
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: (_barcodeText == null)
            ? Text('')
            : _buildNonEmptyBarcodeContents(context, 20));
  }

  Widget _buildNonEmptyBarcodeContents(BuildContext context, int charWidth) {
    final children = _barcodeText!.characters
        .map((ch) => Tooltip(
            message: '0x${ch.codeUnits.first.toRadixString(16)}',
            child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.redAccent,
                  width: 1,
                )),
                child: Center(child: Text(ch)))))
        .toList(growable: false);
    return (_barcodeText!.runes.length < charWidth)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: charWidth,
                children: children));
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
