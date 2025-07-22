import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/ticket_service.dart';

class QRTicket extends StatefulWidget {
  final VoidCallback onClose;

  const QRTicket({super.key, required this.onClose});

  @override
  State<QRTicket> createState() => _QRTicketState();
}

class _QRTicketState extends State<QRTicket>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isClosing = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() async {
    if (_isClosing) return;
    _isClosing = true;

    await _controller.reverse();
    widget.onClose();
  }

  Future<void> _handleScan(String rawValue) async {
    if (_isProcessing) return;
    _isProcessing = true;

    final ticketId = rawValue.trim();

    final result = await TicketService.activateTicket(ticketId);

    if (!mounted) return;

    if (result != null && result.activated) {
      // 🔁 Cập nhật ngôn ngữ toàn app
      final langProvider = context.read<LanguageProvider>();
      langProvider.setLanguage(result.lang);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kích hoạt vé thành công")));
      _handleClose();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kích hoạt thất bại")));
    }

    _isProcessing = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          height: screenHeight * 0.5,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Quét mã QR để kích hoạt vé',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: MobileScanner(
                        fit: BoxFit.contain,
                        onDetect: (capture) {
                          final barcode = capture.barcodes.first;
                          if (barcode.rawValue != null) {
                            _handleScan(barcode.rawValue!);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _handleClose,
                  splashRadius: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
