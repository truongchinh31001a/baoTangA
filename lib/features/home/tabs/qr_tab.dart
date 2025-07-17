import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../services/artifact_service.dart';
import '../../artifact_detail/artifact_detail_screen.dart';

class QrTab extends StatefulWidget {
  const QrTab({super.key});

  @override
  State<QrTab> createState() => _QrTabState();
}

class _QrTabState extends State<QrTab> {
  bool _isProcessing = false;
  String? _lastScannedId;

  void _handleBarcode(String artifactId) async {
    if (_isProcessing || artifactId == _lastScannedId) return;

    _lastScannedId = artifactId;
    setState(() => _isProcessing = true);

    try {
      final lang = context.read<LanguageProvider>().languageCode;
      final artifact = await ArtifactService.fetchArtifact(artifactId, lang);

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArtifactDetailScreen(artifact: artifact),
        ),
      );

      _lastScannedId = null; // reset để có thể scan lại
    } catch (e) {
      debugPrint('Lỗi khi load artifact: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy hiện vật')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
            ),
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                final id = barcode.rawValue;
                if (id != null) {
                  _handleBarcode(id);
                  break;
                }
              }
            },
          ),

          // Khung quét
          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: CustomPaint(painter: _CornerPainter()),
            ),
          ),

          // Loading
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const length = 30.0;

    // 4 góc
    canvas.drawLine(Offset(0, 0), Offset(length, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, length), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - length, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - length), paint);
    canvas.drawLine(Offset(0, size.height), Offset(length, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - length, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - length), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
