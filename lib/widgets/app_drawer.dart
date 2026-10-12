import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'app_logo.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onSheikh;
  final VoidCallback onFavorites;
  final VoidCallback onShare;
  final VoidCallback onContact;
  final VoidCallback onAbout;

  const AppDrawer({
    super.key,
    required this.onHome,
    required this.onSheikh,
    required this.onFavorites,
    required this.onShare,
    required this.onContact,
    required this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      backgroundColor: AppColors.nightDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 6),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _DrawerItem(
                      icon: Icons.home_rounded,
                      label: 'الرئيسية',
                      onTap: onHome,
                    ),
                    _DrawerItem(
                      icon: Icons.person_rounded,
                      label: 'نبذة عن الشيخ',
                      onTap: onSheikh,
                    ),
                    _DrawerItem(
                      icon: Icons.favorite_rounded,
                      label: 'المفضلة',
                      onTap: onFavorites,
                    ),
                    _thinDivider(),
                    _DrawerItem(
                      icon: Icons.share_rounded,
                      label: 'مشاركة التطبيق',
                      onTap: onShare,
                    ),
                    _DrawerItem(
                      icon: Icons.mail_outline_rounded,
                      label: 'تواصل معنا',
                      onTap: onContact,
                    ),
                    _DrawerItem(
                      icon: Icons.info_outline_rounded,
                      label: 'عن التطبيق',
                      onTap: onAbout,
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        children: [
          const AppLogo(size: 80),
          const SizedBox(height: 10),
          Text(
            'خطب العلامة الشيخ',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              color: AppColors.moonCream.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'محمد بن عبدالله الإمام',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 15,
              color: AppColors.mishkatGold,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 1,
                color: AppColors.mishkatGold.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.auto_awesome,
                size: 9,
                color: AppColors.mishkatGold.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Container(
                width: 30,
                height: 1,
                color: AppColors.mishkatGold.withValues(alpha: 0.4),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'دار الحديث بمعبر — ١٤٤٧ هـ',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 10,
              color: AppColors.moonCream.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _thinDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              AppColors.mishkatGold.withValues(alpha: 0.2),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.mishkatGold.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'الإصدار 1.0.0',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 9.5,
              color: AppColors.moonCream.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'تطوير: عبدالرحمن الزبيدي',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 10,
              color: AppColors.mishkatGold.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _isHovered
                    ? AppColors.mishkatGold.withValues(alpha: 0.08)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.mishkatGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 17,
                      color: AppColors.mishkatGold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 13,
                        color: AppColors.moonCream,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}