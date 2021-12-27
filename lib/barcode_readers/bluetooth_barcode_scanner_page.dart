import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BluetoothBarcodeScannerPage extends StatelessWidget {
  const BluetoothBarcodeScannerPage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(title: Text('Barcode Scanner')),
          body: TextField(
              enableSuggestions: false,
              autocorrect: false,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              autofocus: true,
              onSubmitted: (value) => Navigator.pop(context, value)),
        ));
  }
}
