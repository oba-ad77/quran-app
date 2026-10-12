import 'package:flutter/material.dart';
import '../lectures_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../services/app_storage.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Set<int> _favorites = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final favs = await AppStorage.getFavorites();
    if (!mounted) return;
    setState(() {
      _favorites = favs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favLectures = lecturesList
        .where((l) => _favorites.contains(l.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.nightDeep,
      appBar: AppBar(
        backgroundColor: AppColors.nightDeep,
        foregroundColor: AppColors.mishkatGold,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'المفضلة',
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.mishkatGold,
              ),
            )
          : favLectures.isEmpty
              ? _buildEmpty()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favLectures.length,
                  itemBuilder: (context, i) {
                    final lec = favLectures[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.nightWarm,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.mishkatGold.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.mishkatGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '${lec.id}',
                                style: TextStyle(
                                  fontFamily: AppTheme.fontFamily,
                                  color: AppColors.mishkatGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              lec.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 13.5,
                                color: AppColors.moonCream,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite_rounded,
                              color: AppColors.mishkatGold.withValues(alpha: 0.9),
                              size: 20,
                            ),
                            onPressed: () async {
                              await AppStorage.toggleFavorite(lec.id);
                              _load();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 70,
            color: AppColors.mishkatGold.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد خطب في المفضلة',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              color: AppColors.moonCream.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على ♡ في أي خطبة لإضافتها',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              color: AppColors.moonCream.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}