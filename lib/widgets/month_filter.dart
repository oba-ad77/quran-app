import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class MonthFilter extends StatelessWidget {
  final List<String> months;
  final Map<String, int> counts;
  final String? selected;
  final int totalCount;
  final ValueChanged<String?> onSelect;

  const MonthFilter({
    super.key,
    required this.months,
    required this.counts,
    required this.selected,
    required this.totalCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: months.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i == 0) {
            return _chip(
              label: 'الكل',
              count: totalCount,
              active: selected == null,
              onTap: () => onSelect(null),
            );
          }
          final m = months[i - 1];
          return _chip(
            label: m,
            count: counts[m] ?? 0,
            active: selected == m,
            onTap: () => onSelect(m),
          );
        },
      ),
    );
  }

  Widget _chip({
    required String label,
    required int count,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Material(
      color: active
          ? AppColors.mishkatGold
          : AppColors.mishkatGold.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12.5,
                  color: active ? AppColors.nightDeep : AppColors.moonCream,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.nightDeep.withValues(alpha: 0.15)
                      : AppColors.mishkatGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 10,
                    color: active ? AppColors.nightDeep : AppColors.mishkatGold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}