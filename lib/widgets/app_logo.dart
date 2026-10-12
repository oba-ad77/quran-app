import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// شعار "المشكاة" — قبة + مئذنة + هلال
/// مستوحى من سورة النور: ﴿كَمِشْكَاةٍ فِيهَا مِصْبَاحٌ﴾
class AppLogo extends StatelessWidget {
  final double size;
  final bool animated;

  const AppLogo({
    super.key,
    this.size = 200,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MishkatPainter(animated: animated),
      ),
    );
  }
}

class _MishkatPainter extends CustomPainter {
  final bool animated;
  _MishkatPainter({required this.animated});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);

    final Paint goldPaint = Paint()
      ..color = AppColors.mishkatGold
      ..style = PaintingStyle.fill;

    final Paint softGoldPaint = Paint()
      ..color = AppColors.mishkatGoldSoft
      ..style = PaintingStyle.fill;

    // ═══════════════════════════════════════════
    // 1. هالة النور
    // ═══════════════════════════════════════════
    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.mishkatGold.withValues(alpha: 0.35),
          AppColors.mishkatGold.withValues(alpha: 0.10),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: w * 0.5));
    canvas.drawCircle(center, w * 0.48, glowPaint);

    // ═══════════════════════════════════════════
    // 2. القبة
    // ═══════════════════════════════════════════
    final double domeCx = w * 0.5;
    final double domeCy = h * 0.47;
    final double domeW = w * 0.55;
    final double domeH = h * 0.30;
    final Rect domeRect = Rect.fromCenter(
      center: Offset(domeCx, domeCy),
      width: domeW,
      height: domeH * 2,
    );
    final Paint domePaint = Paint()
      ..shader = AppColors.goldGradient.createShader(domeRect);
    canvas.drawArc(domeRect, 3.14159, 3.14159, true, domePaint);

    // ═══════════════════════════════════════════
    // 3. القاعدة
    // ═══════════════════════════════════════════
    final double baseY = h * 0.62;
    final double baseH = h * 0.025;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.18, baseY, w * 0.82, baseY + baseH),
        const Radius.circular(2),
      ),
      goldPaint,
    );

    // ═══════════════════════════════════════════
    // 4. ساق الهلال (تتوقف عند حدّ الهلال السفلي)
    // ═══════════════════════════════════════════
    final double crescentCy = h * 0.075;
    final double crescentR = w * 0.040;

    final double stemTopY = crescentCy + crescentR;
    final double stemBotY = domeCy - domeH;
    canvas.drawRect(
      Rect.fromLTRB(
        domeCx - w * 0.006,
        stemTopY,
        domeCx + w * 0.006,
        stemBotY,
      ),
      goldPaint,
    );

    // ═══════════════════════════════════════════
    // 5. الهلال
    // ═══════════════════════════════════════════
    final Path cOuter = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(domeCx, crescentCy),
        radius: crescentR,
      ));
    final Path cInner = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(
          domeCx + crescentR * 0.42,
          crescentCy - crescentR * 0.12,
        ),
        radius: crescentR * 0.88,
      ));
    final Path crescent =
        Path.combine(PathOperation.difference, cOuter, cInner);
    canvas.drawPath(crescent, softGoldPaint);

    // ═══════════════════════════════════════════
    // 6. جسم المئذنة
    // ═══════════════════════════════════════════
    final double mCx = w * 0.72;
    final double mBodyW = w * 0.06;
    final double mBodyTop = h * 0.20;
    final double mBodyBottom = baseY;

    canvas.drawRect(
      Rect.fromLTRB(
        mCx - mBodyW / 2,
        mBodyTop,
        mCx + mBodyW / 2,
        mBodyBottom,
      ),
      goldPaint,
    );

    // ═══════════════════════════════════════════
    // 7. شرفة المئذنة
    // ═══════════════════════════════════════════
    final double ringY = mBodyTop + h * 0.11;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          mCx - mBodyW * 0.80,
          ringY,
          mCx + mBodyW * 0.80,
          ringY + h * 0.012,
        ),
        const Radius.circular(2),
      ),
      goldPaint,
    );

    // ═══════════════════════════════════════════
    // 8. قبة المئذنة (بصلية)
    // ═══════════════════════════════════════════
    final double capH = h * 0.07;
    final double capW = w * 0.10;
    final double capBaseY = mBodyTop;

    final Path capPath = Path()
      ..moveTo(mCx, capBaseY - capH)
      ..quadraticBezierTo(
        mCx - capW * 0.60,
        capBaseY - capH * 0.55,
        mCx - capW * 0.50,
        capBaseY,
      )
      ..lineTo(mCx + capW * 0.50, capBaseY)
      ..quadraticBezierTo(
        mCx + capW * 0.60,
        capBaseY - capH * 0.55,
        mCx,
        capBaseY - capH,
      )
      ..close();
    canvas.drawPath(capPath, goldPaint);

    // ═══════════════════════════════════════════
    // 9. هلال صغير فوق المئذنة
    // ═══════════════════════════════════════════
    final double mCrescentCy = capBaseY - capH - h * 0.035;
    final double mCrescentR = w * 0.022;

    final Path mcOuter = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(mCx, mCrescentCy),
        radius: mCrescentR,
      ));
    final Path mcInner = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(
          mCx + mCrescentR * 0.42,
          mCrescentCy - mCrescentR * 0.12,
        ),
        radius: mCrescentR * 0.88,
      ));
    final Path mCrescent =
        Path.combine(PathOperation.difference, mcOuter, mcInner);
    canvas.drawPath(mCrescent, softGoldPaint);

    // ═══════════════════════════════════════════
    // 10. نجمات النور — طبقتان (غبار المشكاة)
    // ═══════════════════════════════════════════
    _drawSparkleLayer(
      canvas: canvas,
      center: center,
      w: w,
      radius: w * 0.38,
      count: 8,
      angleOffset: 0,
      baseDotSize: 1.8,
      alpha: 0.40,
    );
    _drawSparkleLayer(
      canvas: canvas,
      center: center,
      w: w,
      radius: w * 0.46,
      count: 8,
      angleOffset: math.pi / 8, // 22.5°
      baseDotSize: 2.6,
      alpha: 0.55,
    );
  }

  // ═══════════════════════════════════════════
  // رسم طبقة نجمات (غبار النور)
  // ═══════════════════════════════════════════
  void _drawSparkleLayer({
    required Canvas canvas,
    required Offset center,
    required double w,
    required double radius,
    required int count,
    required double angleOffset,
    required double baseDotSize,
    required double alpha,
  }) {
    for (int i = 0; i < count; i++) {
      final double angle =
          angleOffset + (i * 2 * math.pi / count);

      // تنويع بسيط في نصف القطر لكل نقطة (للإحساس بالعمق)
      final double rVariation =
          radius + (i % 2 == 0 ? w * 0.012 : -w * 0.012);

      final Offset p = Offset(
        center.dx + rVariation * math.cos(angle),
        center.dy + rVariation * math.sin(angle),
      );

      // أحجام متفاوتة (كأنها نجوم)
      final double dotSize = baseDotSize * (1 + (i % 3) * 0.25);

      final Paint dotPaint = Paint()
        ..color = AppColors.mishkatGold.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(p, dotSize, dotPaint);

      // هالة خفيفة حول كل نقطة
      final Paint haloPaint = Paint()
        ..color = AppColors.mishkatGold.withValues(alpha: alpha * 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(p, dotSize * 2.2, haloPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MishkatPainter oldDelegate) =>
      oldDelegate.animated != animated;
}