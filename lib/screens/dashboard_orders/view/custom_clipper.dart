import 'package:flutter/material.dart';

class SkewCutUpward extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);

    path.lineTo(size.width - 10, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SkewCutUpward oldClipper) => false;
}

class SkewCutDownward extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width, 0); // Start at the top-right corner
    path.lineTo(0, 0); // Move to the top-left corner
    path.lineTo(0, size.height); // Move to the bottom-left corner
    path.lineTo(size.width, size.height); // Move to the bottom-right corner
    path.close(); /// Close

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({required this.color});
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 1, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TrianglePainterNew extends CustomPainter {
  TrianglePainterNew({required this.color});
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 1, 3);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

