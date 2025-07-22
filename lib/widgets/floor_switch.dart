import 'package:flutter/material.dart';

class FloorSwitch extends StatefulWidget {
  final Function(int) onChanged;

  const FloorSwitch({super.key, required this.onChanged});

  @override
  State<FloorSwitch> createState() => _FloorSwitchState();
}

class _FloorSwitchState extends State<FloorSwitch> {
  int selectedFloor = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        children: [
          // Viên trắng trượt mượt
          AnimatedAlign(
            alignment: selectedFloor == 2
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 6.0,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),

          // Text số tầng
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (selectedFloor != 2) {
                      setState(() => selectedFloor = 2);
                      widget.onChanged(2);
                    }
                  },
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: selectedFloor == 2 ? Colors.black : Colors.white,
                      ),
                      child: const Text('2'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (selectedFloor != 1) {
                      setState(() => selectedFloor = 1);
                      widget.onChanged(1);
                    }
                  },
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: selectedFloor == 1 ? Colors.black : Colors.white,
                      ),
                      child: const Text('1'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
