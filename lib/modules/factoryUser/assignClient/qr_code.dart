import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

class QRScannerScreen extends StatefulWidget {
  final String title;

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();

  QRScannerScreen({required this.title});
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;
  bool isDetected = false;

  void _onDetect(BarcodeCapture capture) {
    if (isScanned) return;

    for (final barcode in capture.barcodes) {
      final String? code = barcode.rawValue;
      final List<Offset>? corners = barcode.corners;

      if (code != null && corners != null && corners.length >= 4) {
        final xs = corners.map((e) => e.dx).toList();
        final ys = corners.map((e) => e.dy).toList();

        final left = xs.reduce((a, b) => a < b ? a : b);
        final right = xs.reduce((a, b) => a > b ? a : b);
        final top = ys.reduce((a, b) => a < b ? a : b);
        final bottom = ys.reduce((a, b) => a > b ? a : b);

        final box = Rect.fromLTRB(left, top, right, bottom);
        final Offset center = box.center;

        final screenSize = MediaQuery.of(context).size;
        const double overlaySize = 250;
        final double overlayLeft = (screenSize.width - overlaySize) / 2;
        final double overlayTop = (screenSize.height - overlaySize) / 2;
        final overlayRect = Rect.fromLTWH(
          overlayLeft,
          overlayTop,
          overlaySize,
          overlaySize,
        );

        if (overlayRect.contains(center)) {
          setState(() {
            isDetected = true;
            isScanned = true;
          });

          // Optional: delay to show green border briefly
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context, code);
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
        iconTheme: IconThemeData(color: lightBg),
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),
          QRScannerOverlay(isDetected: isDetected),
        ],
      ),
    );
  }

  /* (BarcodeCapture capture)   {
              if (isScanned) return;
              for (final barcode in capture.barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  isScanned = true;
                  Navigator.pop(context, code);
                  break;
                }
              }
            }*/
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// for Square border over the screen
class QRScannerOverlay extends StatelessWidget {
  final double overlaySize;
  final bool isDetected;

  const QRScannerOverlay({
    this.overlaySize = 250,
    required this.isDetected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        final double left = (width - overlaySize) / 2;
        final double top = (height - overlaySize) / 2;

        return Stack(
          children: [
            // Dim the background
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(width: width, height: height, color: Colors.black),
                  Positioned(
                    left: left,
                    top: top,
                    child: Container(
                      width: overlaySize,
                      height: overlaySize,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),

            // Border: white by default, green if detected
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: overlaySize,
                height: overlaySize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDetected ? Colors.green : Colors.white,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
