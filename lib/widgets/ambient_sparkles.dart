import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// نجمات النور المشتّتة — في الجوانب والأسفل (لا فوق الشعار)
class AmbientSparkles extends StatelessWidget {
  final int count;
  final Color color;

  const AmbientSparkles({
    super.key,
    this.count = 45,
    this.color = AppColors.mishkatGold,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklePainter(count: count, color: color),
      size: Size.infinite,
    );
  }
}

class _SparklePainter extends CustomPainter {
  final int count;
  final Color color;

  _SparklePainter({required this.count, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final math.Random rand = math.Random(42);

    // توزيع: 50% تحت، 25% يسار، 25% يمين
    // المنطقة المحظورة: مربع في المنتصف العلوي (الشعار + النصوص)
    // x من 0.20 إلى 0.80
    // y من 0.05 إلى 0.72

    for (int i = 0; i < count; i++) {
      double x;
      double y;

      final int zone = i % 4;

      if (zone < 2) {
        // المنطقة السفلية (تحت الشعار)
        x = rand.nextDouble() * size.width;
        y = size.height * (0.72 + rand.nextDouble() * 0.28);
      } else if (zone == 2) {
        // الجانب الأيسر
        x = size.width * (0.02 + rand.nextDouble() * 0.16);
        y = size.height * (0.05 + rand.nextDouble() * 0.90);
      } else {
        // الجانب الأيمن
        x = size.width * (0.82 + rand.nextDouble() * 0.16);
        y = size.height * (0.05 + rand.nextDouble() * 0.90);
      }

      final double r = 1.0 + rand.nextDouble() * 2.2;
      final double alpha = 0.12 + rand.nextDouble() * 0.35;

      // النقطة
      final Paint p = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), r, p);

      // هالة خفيفة للنقاط الكبيرة
      if (r > 2.0) {
        final Paint halo = Paint()
          ..color = color.withValues(alpha: alpha * 0.25)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), r * 2.5, halo);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter old) =>
      old.count != count || old.color != color;
}