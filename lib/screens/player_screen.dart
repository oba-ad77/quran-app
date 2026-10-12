import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import '../services/audio_controller.dart';
import '../services/app_storage.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../lectures_data.dart';

class PlayerScreen extends StatefulWidget {
  final Lecture lecture;
  const PlayerScreen({super.key, required this.lecture});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double _speed = 1.0;
  bool _isFav = false;
  bool _repeat = false;

  Timer? _sleepTicker;
  Duration? _sleepRemaining;

  @override
  void initState() {
    super.initState();
    AudioController.isPlayerOpen.value = true;
    _checkFav();
  }

  @override
  void dispose() {
    AudioController.isPlayerOpen.value = false;
    _sleepTicker?.cancel();
    super.dispose();
  }

  Future<void> _checkFav() async {
    final favs = await AppStorage.getFavorites();
    if (!mounted) return;
    setState(() => _isFav = favs.contains(widget.lecture.id));
  }

  Future<void> _toggleFav() async {
    await AppStorage.toggleFavorite(widget.lecture.id);
    _checkFav();
  }

  Future<void> _shareLecture() async {
    await Share.share(
      'خطبة: ${widget.lecture.title}\n'
      'من تطبيق خطب العلامة الشيخ محمد الإمام - دار الحديث بمعبر',
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:$m:$s';
    return '$m:$s';
  }

  String _fmtSleep(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _cycleSpeed() {
    setState(() {
      if (_speed == 1.0) {
        _speed = 1.25;
      } else if (_speed == 1.25) {
        _speed = 1.5;
      } else if (_speed == 1.5) {
        _speed = 2.0;
      } else if (_speed == 2.0) {
        _speed = 0.75;
      } else if (_speed == 0.75) {
        _speed = 0.5;
      } else {
        _speed = 1.0;
      }
    });
    AudioController.player.setPlaybackRate(_speed);
  }

  void _toggleRepeat() {
    setState(() => _repeat = !_repeat);
    AudioController.player.setReleaseMode(
      _repeat ? ReleaseMode.loop : ReleaseMode.release,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _repeat ? 'تكرار الخطبة مُفعّل' : 'التكرار مُعطّل',
          style: TextStyle(fontFamily: AppTheme.fontFamily),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.nightWarm,
      ),
    );
  }

  void _showSleepSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _sleepSheet(),
    );
  }

  void _startSleepTimer(Duration d) {
    _sleepTicker?.cancel();
    Navigator.of(context).pop();

    setState(() => _sleepRemaining = d);

    _sleepTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final rem = _sleepRemaining;
      if (rem == null) return;
      final newRem = rem - const Duration(seconds: 1);
      if (newRem.inSeconds <= 0) {
        _sleepTicker?.cancel();
        AudioController.player.pause();
        setState(() => _sleepRemaining = null);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إيقاف التشغيل — مؤقت النوم',
              style: TextStyle(fontFamily: AppTheme.fontFamily),
            ),
            backgroundColor: AppColors.nightWarm,
          ),
        );
      } else {
        setState(() => _sleepRemaining = newRem);
      }
    });
  }

  void _cancelSleepTimer() {
    _sleepTicker?.cancel();
    Navigator.of(context).pop();
    setState(() => _sleepRemaining = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إلغاء مؤقت النوم',
          style: TextStyle(fontFamily: AppTheme.fontFamily),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.nightWarm,
      ),
    );
  }

  void _showQueue() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _queueSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nightDeep,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxHeight < 700;
            return Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 60,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: isSmall ? 10 : 30),
                            child: Column(
                              children: [
                                _buildLogo(isSmall),
                                SizedBox(height: isSmall ? 16 : 30),
                                _buildTitles(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: isSmall ? 20 : 40,
                              bottom: 100,
                            ),
                            child: Column(
                              children: [
                                _buildProgress(),
                                SizedBox(height: isSmall ? 12 : 20),
                                _buildMainButtons(),
                                SizedBox(height: isSmall ? 16 : 30),
                                _buildBottomButtons(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_rounded),
            color: AppColors.mishkatGold,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            color: AppColors.mishkatGold,
            onPressed: _shareLecture,
          ),
          IconButton(
            icon: Icon(
              _isFav
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
            color: AppColors.mishkatGold,
            onPressed: _toggleFav,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isSmall) {
    final size = isSmall ? 145.0 : 180.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.mishkatGold.withValues(alpha: 0.35),
            AppColors.mishkatGold.withValues(alpha: 0.1),
            Colors.transparent,
          ],
          stops: const [0.3, 0.7, 1.0],
        ),
      ),
      child: AppLogo(size: size),
    );
  }

  Widget _buildTitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Text(
            widget.lecture.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              color: AppColors.moonCream,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'الخطبة رقم ${widget.lecture.id}',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              color: AppColors.mishkatGold.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ValueListenableBuilder<Duration>(
        valueListenable: AudioController.position,
        builder: (_, pos, __) {
          return ValueListenableBuilder<Duration>(
            valueListenable: AudioController.duration,
            builder: (_, dur, __) {
              final total =
                  dur.inMilliseconds > 0 ? dur.inMilliseconds.toDouble() : 1.0;
              final val = pos.inMilliseconds.toDouble().clamp(0.0, total);
              return Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.mishkatGold,
                      inactiveTrackColor:
                          AppColors.mishkatGold.withValues(alpha: 0.15),
                      thumbColor: AppColors.mishkatGold,
                      overlayColor:
                          AppColors.mishkatGold.withValues(alpha: 0.18),
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                    ),
                    child: Slider(
                      value: val,
                      min: 0,
                      max: total,
                      onChanged: (v) => AudioController.seek(
                        Duration(milliseconds: v.toInt()),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _fmt(pos),
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 12,
                            color: AppColors.moonCream.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _fmt(dur),
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 12,
                            color: AppColors.moonCream.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMainButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bigBtn(
          icon: Icons.replay_10_rounded,
          onTap: AudioController.forward10,
        ),
        const SizedBox(width: 24),
        ValueListenableBuilder<bool>(
          valueListenable: AudioController.isPlaying,
          builder: (_, playing, __) => _playPauseBtn(playing),
        ),
        const SizedBox(width: 24),
        _bigBtn(
          icon: Icons.forward_10_rounded,
          onTap: AudioController.rewind10,
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomBtn(
            icon: Icons.queue_music_rounded,
            label: 'قائمة',
            active: false,
            onTap: _showQueue,
          ),
          _bottomBtn(
            icon: Icons.repeat_rounded,
            label: 'تكرار',
            active: _repeat,
            onTap: _toggleRepeat,
          ),
          _bottomBtn(
            icon: Icons.nightlight_round,
            label: _sleepRemaining != null
                ? _fmtSleep(_sleepRemaining!)
                : 'نوم',
            active: _sleepRemaining != null,
            onTap: _showSleepSheet,
          ),
          _bottomBtn(
            icon: Icons.speed_rounded,
            label: '${_speed}x',
            active: _speed != 1.0,
            onTap: _cycleSpeed,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════
  // قائمة الخطب
  // ═══════════════════════════════
  Widget _queueSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.mishkatGold.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.queue_music_rounded,
                color: AppColors.mishkatGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'قائمة الخطب',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 16,
                  color: AppColors.mishkatGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: AppColors.mishkatGold.withValues(alpha: 0.15),
            height: 1,
          ),
          Expanded(
            child: ValueListenableBuilder<int?>(
              valueListenable: AudioController.currentId,
              builder: (_, currentId, __) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: lecturesList.length,
                  itemBuilder: (context, i) {
                    final lec = lecturesList[i];
                    final isCurrent = currentId == lec.id;
                    return Material(
                      color: isCurrent
                          ? AppColors.mishkatGold.withValues(alpha: 0.08)
                          : Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          AudioController.play(lec);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? AppColors.mishkatGold
                                      : AppColors.mishkatGold
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Center(
                                  child: isCurrent
                                      ? const Icon(
                                          Icons.graphic_eq_rounded,
                                          size: 18,
                                          color: AppColors.nightDeep,
                                        )
                                      : Text(
                                          '${lec.id}',
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontFamily,
                                            fontSize: 13,
                                            color: AppColors.moonCream,
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
                                    fontSize: 13,
                                    color: isCurrent
                                        ? AppColors.mishkatGold
                                        : AppColors.moonCream,
                                    fontWeight: isCurrent
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════
  // مؤقت النوم — مُصلح
  // ═══════════════════════════════
  Widget _sleepSheet() {
    final options = [
      ('5 دقائق', const Duration(minutes: 5)),
      ('10 دقائق', const Duration(minutes: 10)),
      ('15 دقيقة', const Duration(minutes: 15)),
      ('30 دقيقة', const Duration(minutes: 30)),
      ('45 دقيقة', const Duration(minutes: 45)),
      ('60 دقيقة', const Duration(minutes: 60)),
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.mishkatGold.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.nightlight_round,
                    color: AppColors.mishkatGold,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'مؤقت النوم',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 16,
                      color: AppColors.mishkatGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_sleepRemaining != null) ...[
                const SizedBox(height: 8),
                Text(
                  'الوقت المتبقي: ${_fmtSleep(_sleepRemaining!)}',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12,
                    color: AppColors.moonCream.withValues(alpha: 0.6),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Divider(
                color: AppColors.mishkatGold.withValues(alpha: 0.15),
                height: 1,
              ),
              const SizedBox(height: 8),
              ...options.map(
                (o) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _startSleepTimer(o.$2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color:
                                AppColors.mishkatGold.withValues(alpha: 0.7),
                            size: 18,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            o.$1,
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 14,
                              color: AppColors.moonCream,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_sleepRemaining != null) ...[
                const SizedBox(height: 6),
                Divider(
                  color: AppColors.mishkatGold.withValues(alpha: 0.15),
                  height: 1,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _cancelSleepTimer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.red.withValues(alpha: 0.85),
                            size: 20,
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'إلغاء المؤقت',
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 14,
                              color: Colors.red.withValues(alpha: 0.95),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bigBtn({
    required IconData icon,
    required Future<void> Function() onTap,
  }) {
    return Material(
      color: AppColors.mishkatGold.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: AppColors.mishkatGold, size: 26),
        ),
      ),
    );
  }

  Widget _playPauseBtn(bool playing) {
    return Material(
      color: AppColors.mishkatGold,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: AudioController.toggle,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Icon(
            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: AppColors.nightDeep,
            size: 36,
          ),
        ),
      ),
    );
  }

  Widget _bottomBtn({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.mishkatGold.withValues(alpha: active ? 0.2 : 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: AppColors.mishkatGold),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 10,
                  color: AppColors.mishkatGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}