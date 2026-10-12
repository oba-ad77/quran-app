import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../lectures_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/month_filter.dart';
import '../services/app_storage.dart';
import '../services/audio_controller.dart';
import 'sheikh_screen.dart';
import 'favorites_screen.dart';
import 'contact_screen.dart';
import 'about_screen.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Set<int> _favorites = {};
  String? _selectedMonth;

  static const List<String> _monthOrder = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await AppStorage.getFavorites();
    if (!mounted) return;
    setState(() => _favorites = favs);
  }

  Map<String, int> _monthCounts() {
    final m = <String, int>{};
    for (final l in lecturesList) {
      if (l.month != null) {
        m[l.month!] = (m[l.month!] ?? 0) + 1;
      }
    }
    return m;
  }

  List<String> _monthsWithData() {
    final counts = _monthCounts();
    return _monthOrder.where((m) => (counts[m] ?? 0) > 0).toList();
  }

  List<Lecture> _filtered() {
    if (_selectedMonth == null) return lecturesList;
    return lecturesList.where((l) => l.month == _selectedMonth).toList();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:$m:$s';
    return '$m:$s';
  }

  Future<void> _toggleFav(int id) async {
    await AppStorage.toggleFavorite(id);
    await _loadFavorites();
  }

  Future<void> _shareApp() async {
    await Share.share(
      'تطبيق خطب العلامة الشيخ محمد بن عبدالله الإمام - دار الحديث بمعبر',
    );
  }

  Future<void> _shareLecture(Lecture lec) async {
    await Share.share(
      'خطبة: ${lec.title}\nمن تطبيق خطب العلامة الشيخ محمد الإمام',
    );
  }

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  Future<void> _navigateFromDrawer(Widget screen) async {
    Navigator.of(context).pop();
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    if (!mounted) return;
    _openDrawer();
  }

  Future<void> _openPlayer(Lecture lecture) async {
    await AudioController.play(lecture);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlayerScreen(lecture: lecture)),
    );
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final months = _monthsWithData();
    final counts = _monthCounts();
    final list = _filtered();

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        onHome: () => Navigator.of(context).pop(),
        onSheikh: () => _navigateFromDrawer(const SheikhScreen()),
        onFavorites: () => _navigateFromDrawer(const FavoritesScreen()),
        onShare: () {
          Navigator.of(context).pop();
          _shareApp();
        },
        onContact: () => _navigateFromDrawer(const ContactScreen()),
        onAbout: () => _navigateFromDrawer(const AboutScreen()),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.mishkatGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.mosque_rounded,
                color: AppColors.mishkatGold,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'خطب العلامة الشيخ محمد الإمام',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.moonCream,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'دار الحديث بمعبر — ١٤٤٧ هـ',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.mishkatGold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: _openDrawer,
            tooltip: 'القائمة',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          MonthFilter(
            months: months,
            counts: counts,
            selected: _selectedMonth,
            totalCount: lecturesList.length,
            onSelect: (m) => setState(() => _selectedMonth = m),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final lec = list[i];
                final isFav = _favorites.contains(lec.id);
                return ValueListenableBuilder<int?>(
                  valueListenable: AudioController.currentId,
                  builder: (_, currentId, __) {
                    return _LectureCard(
                      lecture: lec,
                      isSelected: currentId == lec.id,
                      isFavorite: isFav,
                      onTap: () => _openPlayer(lec),
                      onFavorite: () => _toggleFav(lec.id),
                      onShare: () => _shareLecture(lec),
                      formatDuration: _fmt,
                    );
                  },
                );
              }
            ),
          ),
          
          const _Footer(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// بطاقة الخطبة
// ═══════════════════════════════════════════════
class _LectureCard extends StatelessWidget {
  final Lecture lecture;
  final bool isSelected;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final String Function(Duration) formatDuration;

  const _LectureCard({
    required this.lecture,
    required this.isSelected,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
    required this.onShare,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.mishkatGold
              : AppColors.mishkatGold.withValues(alpha: 0.12),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mishkatGold
                        : AppColors.mishkatGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Text(
                      '${lecture.id}',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        color: isSelected
                            ? AppColors.nightDeep
                            : AppColors.moonCream,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lecture.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.moonCream,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.graphic_eq_rounded
                                : Icons.touch_app_rounded,
                            size: 13,
                            color: isSelected
                                ? AppColors.mishkatGold
                                : AppColors.mishkatGold.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isSelected ? 'جاري التشغيل' : 'انقر للاستماع',
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 10.5,
                              color: isSelected
                                  ? AppColors.mishkatGold
                                  : AppColors.moonCream.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  children: [
                    _iconBtn(
                      icon: isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      onTap: onFavorite,
                      active: isFavorite,
                    ),
                    const SizedBox(height: 4),
                    _iconBtn(icon: Icons.share_rounded, onTap: onShare),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            icon,
            size: 18,
            color: active
                ? AppColors.mishkatGold
                : AppColors.moonCream.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// التذييل
// ═══════════════════════════════════════════════
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.nightWarm,
        border: Border(
          top: BorderSide(
            color: AppColors.mishkatGold.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code_rounded,
            size: 14,
            color: AppColors.mishkatGold.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 6),
          Text(
            'تم التطوير بواسطة: عبدالرحمن الزبيدي',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.mishkatGold.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}