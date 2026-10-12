import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import '../lectures_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../services/app_storage.dart';

class FullPlayerScreen extends StatefulWidget {
  final AudioPlayer player;
  final Lecture lecture;
  const FullPlayerScreen({
    super.key,
    required this.player,
    required this.lecture,
  });

  @override
  State<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends State<FullPlayerScreen> {
  AudioPlayer get _audioPlayer => widget.player;

  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isDragging = false;
  double _dragValue = 0;
  double _speed = 1.0;
  bool _isFavorite = false;

  Timer? _sleepCountdown;
  Duration? _sleepRemaining;
  int _repeatMode = 0;

  @override
  void initState() {
    super.initState();
    _attach();
    _loadFavorite();
    _syncState();
  }

  void _attach() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _isPlaying = state == PlayerState.playing);
    });
    _audioPlayer.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted || _isDragging) return;
      setState(() => _position = p);
    });
    _audioPlayer.onPlayerComplete.listen((_) => _onComplete());
  }

  Future<void> _syncState() async {
    try {
      final pos = await _audioPlayer.getCurrentPosition();
      final dur = await _audioPlayer.getDuration();
      if (!mounted) return;
      setState(() {
        _position = pos ?? Duration.zero;
        _duration = dur ?? Duration.zero;
        _isPlaying = _audioPlayer.state == PlayerState.playing;
      });
    } catch (_) {}
  }

  Future<void> _loadFavorite() async {
    final favs = await AppStorage.getFavorites();
    if (!mounted) return;
    setState(() => _isFavorite = favs.contains(widget.lecture.id));
  }

  Future<void> _toggleFavorite() async {
    await AppStorage.toggleFavorite(widget.lecture.id);
    await _loadFavorite();
  }

  Future<void> _shareLecture() async {
    await Share.share(
      'خطبة: ${widget.lecture.title}\n'
      'من تطبيق خطب العلامة الشيخ محمد الإمام - دار الحديث بمعبر',
    );
  }

  Future<void> _onComplete() async {
    if (_duration.inSeconds > 0) {
      await AppStorage.addListenedLecture(_duration.inSeconds);
    }
    await AppStorage.clearPosition(widget.lecture.id);

    if (_repeatMode == 1) {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.resume();
      return;
    }
    if (_repeatMode == 2) {
      _playNext();
      return;
    }
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    }
  }

  void _playNext() {
    final idx = lecturesList.indexWhere((l) => l.id == widget.lecture.id);
    if (idx >= 0 && idx < lecturesList.length - 1) {
      final next = lecturesList[idx + 1];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FullPlayerScreen(
            player: widget.player,
            lecture: next,
          ),
        ),
      );
    } else {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    }
  }

  @override
  void dispose() {
    _sleepCountdown?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  TextStyle get _timeStyle => TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: 12,
        color: AppColors.moonCream.withValues(alpha: 0.85),
      );

  void _showSleepSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.nightWarm,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SleepSheet(
        remaining: _sleepRemaining,
        onSelect: (m) {
          Navigator.pop(context);
          _startSleepTimer(m);
        },
        onCancel: () {
          Navigator.pop(context);
          _cancelSleepTimer();
        },
      ),
    );
  }

  void _startSleepTimer(int minutes) {
    _sleepCountdown?.cancel();
    final total = Duration(minutes: minutes);
    setState(() => _sleepRemaining = total);

    _sleepCountdown = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      final rem = _sleepRemaining! - const Duration(seconds: 1);
      if (rem.inSeconds <= 0) {
        t.cancel();
        _audioPlayer.pause();
        setState(() => _sleepRemaining = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إيقاف التشغيل — مؤقّت النوم'),
            backgroundColor: AppColors.nightWarm,
          ),
        );
      } else {
        setState(() => _sleepRemaining = rem);
      }
    });
  }

  void _cancelSleepTimer() {
    _sleepCountdown?.cancel();
    setState(() => _sleepRemaining = null);
  }

  void _toggleRepeat() {
    setState(() => _repeatMode = (_repeatMode + 1) % 3);
    const labels = ['بدون تكرار', 'تكرار الخطبة', 'تكرار الكل'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(labels[_repeatMode]),
        duration: const Duration(milliseconds: 1200),
        backgroundColor: AppColors.nightWarm,
      ),
    );
  }

  void _showQueueSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.nightWarm,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => _QueueSheet(
        currentId: widget.lecture.id,
        onSelect: (lec) async {
          Navigator.pop(context);
          await _audioPlayer.stop();
          await _audioPlayer.play(AssetSource(lec.path));
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => FullPlayerScreen(
                player: widget.player,
                lecture: lec,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSpeedSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.nightWarm,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SpeedSheet(
        current: _speed,
        onSelect: (v) async {
          setState(() => _speed = v);
          await _audioPlayer.setPlaybackRate(v);
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxMs = _duration.inMilliseconds > 0
        ? _duration.inMilliseconds.toDouble()
        : 1.0;
    final sliderValue = _isDragging
        ? _dragValue
        : _position.inMilliseconds.toDouble().clamp(0.0, maxMs).toDouble();
    final displayPos = _isDragging
        ? Duration(milliseconds: _dragValue.toInt())
        : _position;

    return Scaffold(
      backgroundColor: AppColors.nightDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
          color: AppColors.mishkatGold,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
            color: AppColors.mishkatGold,
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            color: AppColors.mishkatGold,
            onPressed: _shareLecture,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.mishkatGold.withValues(alpha: 0.35),
                      AppColors.mishkatGold.withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mishkatGold.withValues(alpha: 0.15),
                      border: Border.all(
                        color: AppColors.mishkatGold.withValues(alpha: 0.55),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.mishkatGold.withValues(alpha: 0.35),
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mosque_rounded,
                      color: AppColors.mishkatGold,
                      size: 62,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                widget.lecture.title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.moonCream,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'الخطبة رقم ${widget.lecture.id}',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mishkatGold.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(flex: 1),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.mishkatGold,
                  inactiveTrackColor:
                      AppColors.mishkatGold.withValues(alpha: 0.15),
                  thumbColor: AppColors.mishkatGold,
                  overlayColor: AppColors.mishkatGold.withValues(alpha: 0.20),
                  trackHeight: 5,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: sliderValue.clamp(0.0, maxMs).toDouble(),
                  min: 0,
                  max: maxMs,
                  onChangeStart: (v) => setState(() {
                    _isDragging = true;
                    _dragValue = v;
                  }),
                  onChanged: (v) => setState(() => _dragValue = v),
                  onChangeEnd: (v) async {
                    await _audioPlayer.seek(Duration(milliseconds: v.toInt()));
                    if (!mounted) return;
                    setState(() {
                      _isDragging = false;
                      _position = Duration(milliseconds: v.toInt());
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_format(displayPos), style: _timeStyle),
                    Text(_format(_duration), style: _timeStyle),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CircleBtn(
                    icon: Icons.replay_10_rounded,
                    onTap: () async {
                      await _audioPlayer
                          .seek(_position + const Duration(seconds: 10));
                    },
                  ),
                  const SizedBox(width: 28),
                  _PlayBtn(
                    isPlaying: _isPlaying,
                    onTap: () async {
                      if (_isPlaying) {
                        await _audioPlayer.pause();
                      } else {
                        await _audioPlayer.resume();
                      }
                    },
                  ),
                  const SizedBox(width: 28),
                  _CircleBtn(
                    icon: Icons.forward_10_rounded,
                    onTap: () async {
                      final n = _position - const Duration(seconds: 10);
                      await _audioPlayer
                          .seek(n.isNegative ? Duration.zero : n);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomBtn(
                    icon: Icons.speed_rounded,
                    label: '${_speed}x',
                    active: _speed != 1.0,
                    onTap: _showSpeedSheet,
                  ),
                  _BottomBtn(
                    icon: Icons.bedtime_rounded,
                    label: _sleepRemaining != null
                        ? _format(_sleepRemaining!)
                        : 'نوم',
                    active: _sleepRemaining != null,
                    onTap: _showSleepSheet,
                  ),
                  _BottomBtn(
                    icon: _repeatMode == 1
                        ? Icons.repeat_one_rounded
                        : Icons.repeat_rounded,
                    label: _repeatMode == 0
                        ? 'تكرار'
                        : (_repeatMode == 1 ? 'خطبة' : 'الكل'),
                    active: _repeatMode != 0,
                    onTap: _toggleRepeat,
                  ),
                  _BottomBtn(
                    icon: Icons.queue_music_rounded,
                    label: 'قائمة',
                    active: false,
                    onTap: _showQueueSheet,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  الأزرار
// ═══════════════════════════════════════════════════════════

class _PlayBtn extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;
  const _PlayBtn({required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.mishkatGold,
          boxShadow: [
            BoxShadow(
              color: AppColors.mishkatGold.withValues(alpha: 0.45),
              blurRadius: 30,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: AppColors.nightDeep,
          size: 44,
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.mishkatGold.withValues(alpha: 0.12),
          border: Border.all(
            color: AppColors.mishkatGold.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(icon, color: AppColors.mishkatGold, size: 26),
      ),
    );
  }
}

class _BottomBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _BottomBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.mishkatGold
        : AppColors.moonCream.withValues(alpha: 0.8);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.mishkatGold.withValues(alpha: 0.15)
                  : AppColors.nightWarm,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: active
                    ? AppColors.mishkatGold.withValues(alpha: 0.6)
                    : AppColors.mishkatGold.withValues(alpha: 0.25),
              ),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Bottom Sheets
// ═══════════════════════════════════════════════════════════

class _SpeedSheet extends StatelessWidget {
  final double current;
  final ValueChanged<double> onSelect;
  const _SpeedSheet({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Handle(),
          const SizedBox(height: 18),
          const Text(
            'سرعة التشغيل',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.moonCream,
            ),
          ),
          const SizedBox(height: 12),
          ...speeds.map((s) => ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  '${s}x',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: s == current
                        ? AppColors.mishkatGold
                        : AppColors.moonCream,
                    fontWeight:
                        s == current ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: s == current
                    ? const Icon(Icons.check_rounded,
                        color: AppColors.mishkatGold)
                    : null,
                onTap: () => onSelect(s),
              )),
        ],
      ),
    );
  }
}

class _SleepSheet extends StatelessWidget {
  final Duration? remaining;
  final ValueChanged<int> onSelect;
  final VoidCallback onCancel;
  const _SleepSheet({
    required this.remaining,
    required this.onSelect,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = [5, 10, 15, 30, 45, 60];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Handle(),
          const SizedBox(height: 18),
          const Text(
            'مؤقّت النوم',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.moonCream,
            ),
          ),
          if (remaining != null) ...[
            const SizedBox(height: 8),
            Text(
              'متبقي: ${remaining!.inMinutes}:${(remaining!.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.mishkatGold,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: minutes.map((m) {
              return InkWell(
                onTap: () => onSelect(m),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.mishkatGold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.mishkatGold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    '$m دقيقة',
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mishkatGold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (remaining != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onCancel,
              icon: const Icon(Icons.close_rounded,
                  color: AppColors.mishkatGold, size: 18),
              label: const Text(
                'إلغاء المؤقّت',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: AppColors.mishkatGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QueueSheet extends StatelessWidget {
  final int currentId;
  final ValueChanged<Lecture> onSelect;
  const _QueueSheet({required this.currentId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Container(
      height: media.height * 0.75,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        children: [
          const _Handle(),
          const SizedBox(height: 14),
          const Text(
            'قائمة الخطب',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.moonCream,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: lecturesList.length,
              itemBuilder: (_, i) {
                final lec = lecturesList[i];
                final isCurrent = lec.id == currentId;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.mishkatGold
                          : AppColors.mishkatGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isCurrent
                        ? const Icon(Icons.graphic_eq_rounded,
                            color: AppColors.nightDeep, size: 18)
                        : Text(
                            '${lec.id}',
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mishkatGold,
                            ),
                          ),
                  ),
                  title: Text(
                    lec.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 13,
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent
                          ? AppColors.mishkatGold
                          : AppColors.moonCream,
                    ),
                  ),
                  onTap: isCurrent ? null : () => onSelect(lec),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.mishkatGold.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}