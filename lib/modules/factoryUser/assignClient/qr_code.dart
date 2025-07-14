import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR")),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) {
          if (isScanned) return;

          // ✅ Correct: handle list of barcodes
          for (final barcode in capture.barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              isScanned = true;
              Navigator.pop(context, code);
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
