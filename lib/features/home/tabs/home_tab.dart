import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ảnh nền: lấy phần giữa ảnh
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        // Lớp overlay mờ nhẹ
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
        // Chữ ở trên cùng
        const Positioned(
          top: 48,
          left: 24,
          right: 24,
          child: Text(
            'Bảo tàng y khoa\nApollo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'RibeyeMarrow',
              fontSize: 32,
              color: Colors.white,
              height: 1.3,
              shadows: [
                Shadow(
                  color: Colors.black45,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
