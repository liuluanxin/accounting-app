import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final List<_ChartSlice> slices;
  final double size;

  const DonutChart({
    super.key,
    required this.slices,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    if (slices.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF0E8FA),
        ),
        child: const Center(
          child: Text('暂无数据',
              style: TextStyle(
                  fontSize: 13, color: Color(0xFF5A6788))),
        ),
      );
    }

    final total = slices.fold(0.0, (sum, s) => sum + s.value);
    final stops = <double>[];
    var accumulated = 0.0;
    for (final slice in slices) {
      stops.add(accumulated / total);
      accumulated += slice.value;
      stops.add(accumulated / total);
    }

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutPainter(slices: slices, total: total),
        child: Center(
          child: Container(
            width: size * 0.52,
            height: size * 0.52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<_ChartSlice> slices;
  final double total;

  _DonutPainter({required this.slices, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) return;
    final rect = Offset.zero & size;
    final paint = Paint()..style = PaintingStyle.fill;
    var startAngle = -1.5708; // 从顶部开始

    for (final slice in slices) {
      final sweepAngle = (slice.value / total) * 6.28319;
      paint.color = slice.color;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return total != oldDelegate.total;
  }
}

class _ChartSlice {
  final double value;
  final Color color;
  _ChartSlice({required this.value, required this.color});
}
