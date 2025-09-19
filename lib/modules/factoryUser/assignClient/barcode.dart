import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/////////////////////////NOT IN USED/////////////////////////////////////////

class BarcodeScannerScreen extends StatefulWidget {
  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Barcode or QR")),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) {
          if (scanned) return;

          for (final barcode in capture.barcodes) {
            final String? code = barcode.rawValue;
            final BarcodeType type = barcode.type;

            if (code != null) {
              scanned = true;
              Navigator.pop(context, "Type: $type\nCode: $code");
              break;
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
