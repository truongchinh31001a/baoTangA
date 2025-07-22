import 'package:flutter/material.dart';
import '../../../widgets/floor_switch.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  int selectedFloor = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloorSwitch(
          onChanged: (floor) {
            setState(() {
              selectedFloor = floor;
            });
          },
        ),
        const SizedBox(height: 20),
        Text(
          'Đang chọn tầng $selectedFloor',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
