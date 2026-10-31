import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = const [
      ('Ăn uống', '2.000.000 đ', 0.40, Color(0xFFFF6268)),
      ('Mua sắm', '1.500.000 đ', 0.30, Color(0xFF2878E8)),
      ('Đi lại', '700.000 đ', 0.14, Color(0xFF42B866)),
      ('Học tập', '500.000 đ', 0.10, Color(0xFF8B5CF6)),
      ('Khác', '300.000 đ', 0.06, Color(0xFFF59E0B)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18243A),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: ['Tháng này', 'Tháng trước', 'Năm nay'].map((label) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: label == 'Tháng này'
                          ? const Color(0xFF2878E8)
                          : Colors.white,
                      foregroundColor: label == 'Tháng này'
                          ? Colors.white
                          : const Color(0xFF687386),
                    ),
                    child: Text(label, style: const TextStyle(fontSize: 11)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              height: 210,
              width: 210,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size.square(210),
                    painter: _StatisticsChartPainter(),
                  ),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '5.000.000 đ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Tổng chi tiêu',
                        style: TextStyle(color: Color(0xFF8993A4)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(radius: 5, backgroundColor: category.$4),
                  const SizedBox(width: 10),
                  Expanded(child: Text(category.$1)),
                  Text(category.$2),
                  const SizedBox(width: 16),
                  Text('${(category.$3 * 100).round()}%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    final values = [0.40, 0.30, 0.14, 0.10, 0.06];
    final colors = [
      const Color(0xFFFF6268),
      const Color(0xFF2878E8),
      const Color(0xFF42B866),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
    ];
    var start = -1.5708;
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] * 6.2832;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 28,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
