import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  static const String _email = 'aboodalzbidi50@gmail.com';
  static const String _phone = '+967778191577';
  static const String _whatsapp = '967778191577';

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح الرابط')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح الرابط')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nightDeep,
      appBar: AppBar(
        backgroundColor: AppColors.nightDeep,
        foregroundColor: AppColors.mishkatGold,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تواصل معنا',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 16,
            color: AppColors.mishkatGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.mishkatGold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.forum_rounded,
            size: 60,
            color: AppColors.mishkatGold.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'نسعد بتواصلك معنا',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 18,
              color: AppColors.mishkatGold,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'لأي استفسار أو اقتراح أو ملاحظة',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              color: AppColors.moonCream.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _ContactCard(
            icon: Icons.email_rounded,
            title: 'البريد الإلكتروني',
            subtitle: _email,
            onTap: () => _open(context, 'mailto:$_email'),
          ),
          const SizedBox(height: 12),
          _ContactCard(
            icon: Icons.phone_rounded,
            title: 'الهاتف',
            subtitle: _phone,
            onTap: () => _open(context, 'tel:$_phone'),
          ),
          const SizedBox(height: 12),
          _ContactCard(
            icon: Icons.chat_bubble_rounded,
            title: 'واتساب',
            subtitle: '+$_whatsapp',
            onTap: () => _open(context, 'https://wa.me/_whatsapp'),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.nightWarm,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.mishkatGold.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.mishkatGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.mishkatGold, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 14,
                        color: AppColors.moonCream,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: AppColors.moonCream.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w500,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_rounded,
                size: 14,
                color: AppColors.mishkatGold.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}