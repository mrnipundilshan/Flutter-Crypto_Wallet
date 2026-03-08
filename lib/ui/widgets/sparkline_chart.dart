import 'package:flutter/material.dart';

class SparklineChart extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;
  final double strokeWidth;

  SparklineChart({
    required this.data,
    required this.lineColor,
    Color? fillColor,
    this.strokeWidth = 2.0,
  }) : fillColor = fillColor ?? lineColor.withValues(alpha: 0.15);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minVal = data.reduce((a, b) => a < b ? a : b);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;
    if (range == 0) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i] - minVal) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        // Use cubic bezier for smooth curves
        final prevX = ((i - 1) / (data.length - 1)) * size.width;
        final prevY =
            size.height - ((data[i - 1] - minVal) / range) * size.height;
        final cp1x = prevX + (x - prevX) / 2;
        final cp2x = prevX + (x - prevX) / 2;
        path.cubicTo(cp1x, prevY, cp2x, y, x, y);
        fillPath.cubicTo(cp1x, prevY, cp2x, y, x, y);
      }
    }

    // Close fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fillColor, fillColor.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dot at last point
    final lastX = size.width;
    final lastY = size.height - ((data.last - minVal) / range) * size.height;
    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(lastX, lastY), 3, dotPaint);

    final glowPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(lastX, lastY), 6, glowPaint);
  }

  @override
  bool shouldRepaint(covariant SparklineChart oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor;
  }
}

class SparklineWidget extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double height;
  final double width;

  const SparklineWidget({
    super.key,
    required this.data,
    required this.color,
    this.height = 40,
    this.width = 80,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: SparklineChart(data: data, lineColor: color),
    );
  }
}
