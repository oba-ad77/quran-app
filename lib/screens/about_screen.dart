import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/ambient_sparkles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nightDeep,
      body: Stack(
        children: [
          const Positioned.fill(
            child: AmbientSparkles(count: 30),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.nightDeep,
                foregroundColor: AppColors.mishkatGold,
                elevation: 0,
                centerTitle: true,
                pinned: true,
                title: Text(
                  'عن التطبيق',
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
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Center(child: const AppLogo(size: 140)),
                    const SizedBox(height: 24),
                    Text(
                      'خطب العلامة الشيخ محمد الإمام',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 18,
                        color: AppColors.mishkatGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'دار الحديث بمعبر — ١٤٤٧ هـ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 12,
                        color: AppColors.moonCream.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _card(
                      title: 'عن التطبيق',
                      body:
                          'تطبيق يجمع خطب الجمعة للعلامة الشيخ محمد بن عبدالله الإمام - حفظه الله - مع نبذة عن سيرته ومؤلفاته.',
                    ),
                    const SizedBox(height: 14),
                    _card(
                      title: 'الإصدار',
                      body: '1.0.0',
                    ),
                    const SizedBox(height: 14),
                    _card(
                      title: 'المطوّر',
                      body: 'عبدالرحمن الزبيدي',
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 1,
                          color: AppColors.mishkatGold.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: AppColors.mishkatGold.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 40,
                          height: 1,
                          color: AppColors.mishkatGold.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'غفر الله له ولوالديه ولأحبابه والمسلمين',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 11,
                        color: AppColors.mishkatGold.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required String body}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.mishkatGold.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              color: AppColors.mishkatGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13.5,
              color: AppColors.moonCream.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}