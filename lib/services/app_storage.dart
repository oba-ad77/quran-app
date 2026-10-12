import 'package:shared_preferences/shared_preferences.dart';

/// خدمة تخزين محلية — المفضلة + الإحصائيات
class AppStorage {
  AppStorage._();

  static const String _favKey = 'favorites';
  static const String _listenedKey = 'listened_count';
  static const String _totalSecondsKey = 'total_seconds';

  // ═══════════════════════════════
  // المفضلة
  // ═══════════════════════════════
  static Future<Set<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? raw = prefs.getStringList(_favKey);
    if (raw == null) return <int>{};
    return raw.map(int.parse).toSet();
  }

  static Future<void> toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getFavorites();
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    await prefs.setStringList(
      _favKey,
      current.map((e) => e.toString()).toList(),
    );
  }

  // ═══════════════════════════════
  // الإحصائيات
  // ═══════════════════════════════
  static Future<void> addListenedLecture(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final int count = prefs.getInt(_listenedKey) ?? 0;
    final int totalSecs = prefs.getInt(_totalSecondsKey) ?? 0;

    await prefs.setInt(_listenedKey, count + 1);
    await prefs.setInt(_totalSecondsKey, totalSecs + seconds);
  }

  static Future<Map<String, dynamic>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final int count = prefs.getInt(_listenedKey) ?? 0;
    final int totalSecs = prefs.getInt(_totalSecondsKey) ?? 0;

    final int hours = totalSecs ~/ 3600;
    final int minutes = (totalSecs % 3600) ~/ 60;

    return {
      'count': count,
      'hours': hours,
      'minutes': minutes,
    };
  }
  static Future<void> savePosition(int id, int ms) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('pos_$id', ms);
}

static Future<int> getPosition(int id) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('pos_$id') ?? 0;
}

static Future<void> clearPosition(int id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('pos_$id');
}
}
