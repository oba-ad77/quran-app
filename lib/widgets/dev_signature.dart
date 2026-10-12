import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// شعار شخصي فاخر للمطور — توقيع فني مدمج
class DevSignature extends StatefulWidget {
  final double width;

  const DevSignature({super.key, this.width = 260});

  @override
  State<DevSignature> createState() => _DevSignatureState();
}

class _DevSignatureState extends State<DevSignature>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ═══════════════════════════════
          // خط علوي ذهبي مع نجمة
          // ═══════════════════════════════
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _gradientLine(reversed: true),
              const SizedBox(width: 8),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return Transform.rotate(
                    angle: _pulseController.value * 0.4,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 11,
                      color: AppColors.mishkatGold.withValues(
                        alpha: 0.6 + _pulseController.value * 0.4,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              _gradientLine(),
            ],
          ),

          const SizedBox(height: 14),

          // ═══════════════════════════════
          // الاسم — بين رمزي كود < >
          // ═══════════════════════════════
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '< ',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mishkatGold.withValues(alpha: 0.65),
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    colors: [
                      AppColors.mishkatGoldSoft,
                      AppColors.mishkatGold,
                      AppColors.mishkatGoldSoft,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ).createShader(bounds);
                },
                child: Text(
                  'عبدالرحمن الزبيدي',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        color: AppColors.mishkatGold.withValues(alpha: 0.5),
                        blurRadius: 14,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                ' />',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mishkatGold.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ═══════════════════════════════
          // خط ذهبي سفلي
          // ═══════════════════════════════
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.mishkatGold.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ═══════════════════════════════
          // رمز الكود + كلمة Developer
          // ═══════════════════════════════
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '>_',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mishkatGold.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'DEVELOPER',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: AppColors.mishkatGold.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gradientLine({bool reversed = false}) {
    return Container(
      width: 50,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: reversed ? Alignment.centerRight : Alignment.centerLeft,
          end: reversed ? Alignment.centerLeft : Alignment.centerRight,
          colors: [
            Colors.transparent,
            AppColors.mishkatGold.withValues(alpha: 0.7),
          ],
        ),
      ),
    );
  }
}