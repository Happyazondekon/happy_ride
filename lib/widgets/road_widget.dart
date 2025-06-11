import 'package:flutter/material.dart';

class RoadWidget extends StatefulWidget {
  const RoadWidget({super.key});

  @override
  State<RoadWidget> createState() => _RoadWidgetState();
}

class _RoadWidgetState extends State<RoadWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust speed of road lines
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _RoadPainter(_animation.value),
        );
      },
    );
  }
}

class _RoadPainter extends CustomPainter {
  final double animationValue;

  _RoadPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint roadPaint = Paint()..color = const Color(0xFF333333); // Dark grey for road
    final Paint lanePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // Draw road background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), roadPaint);

    // Draw lane lines
    final double laneWidth = size.width / 3;
    final double dashLength = 40;
    final double dashSpace = 30;

    for (int i = -3; i < size.height / (dashLength + dashSpace) + 3; i++) {
      final double y = (i * (dashLength + dashSpace) + (animationValue * (dashLength + dashSpace))) % (size.height + dashLength + dashSpace);

      // Left lane line
      canvas.drawLine(
        Offset(laneWidth, y),
        Offset(laneWidth, y + dashLength),
        lanePaint,
      );

      // Right lane line
      canvas.drawLine(
        Offset(laneWidth * 2, y),
        Offset(laneWidth * 2, y + dashLength),
        lanePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as _RoadPainter).animationValue != animationValue;
  }
}