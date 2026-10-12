import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import '../lectures_data.dart';
import 'app_storage.dart';

/// ═══════════════════════════════════════════
/// Audio Handler للخلفية (Android فقط)
/// ═══════════════════════════════════════════
class _AppAudioHandler extends BaseAudioHandler {
  final AudioPlayer player;

  _AppAudioHandler(this.player) {
    player.onPlayerStateChanged.listen((s) {
      playbackState.add(playbackState.value.copyWith(
        playing: s == PlayerState.playing,
        processingState: s == PlayerState.completed
            ? AudioProcessingState.completed
            : AudioProcessingState.ready,
        controls: [
          MediaControl.rewind,
          if (s == PlayerState.playing)
            MediaControl.pause
          else
            MediaControl.play,
          MediaControl.fastForward,
        ],
        systemActions: const {MediaAction.seek},
      ));
    });

    player.onPositionChanged.listen((p) {
      playbackState.add(playbackState.value.copyWith(updatePosition: p));
    });
  }

  void setMediaItem(MediaItem item) {
    mediaItem.add(item);
  }

  @override
  Future<void> play() => player.resume();

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> stop() async {
    await player.stop();
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> fastForward() async {
    final pos = AudioController.position.value;
    await player.seek(pos + const Duration(seconds: 10));
  }

  @override
  Future<void> rewind() async {
    final pos = AudioController.position.value;
    final newPos = pos - const Duration(seconds: 10);
    await player.seek(newPos.isNegative ? Duration.zero : newPos);
  }
}

/// ═══════════════════════════════════════════
/// المتحكم المركزي
/// ═══════════════════════════════════════════
class AudioController {
  AudioController._();

  static final AudioPlayer player = AudioPlayer();
  static _AppAudioHandler? _handler;
  static bool _init = false;

  static final ValueNotifier<int?> currentId = ValueNotifier<int?>(null);
  static final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  static final ValueNotifier<Duration> position =
      ValueNotifier<Duration>(Duration.zero);
  static final ValueNotifier<Duration> duration =
      ValueNotifier<Duration>(Duration.zero);
  static final ValueNotifier<int> statsVersion = ValueNotifier<int>(0);
  static final ValueNotifier<bool> isPlayerOpen =
      ValueNotifier<bool>(false);

  static Future<void> initAsync() async {
    if (_init) return;
    _init = true;

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
    } catch (_) {}

    try {
      final h = await AudioService.init(
        builder: () => _AppAudioHandler(player),
        config: const AudioServiceConfig(
          androidNotificationChannelId:
              'com.example.quran_app.channel.audio',
          androidNotificationChannelName: 'مشغل الخطب',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
      );
      _handler = h;
    } catch (_) {
      _handler = null;
    }

    player.onPlayerStateChanged.listen((s) {
      isPlaying.value = s == PlayerState.playing;
    });

    player.onDurationChanged.listen((d) => duration.value = d);
    player.onPositionChanged.listen((p) => position.value = p);

    player.onPlayerComplete.listen((_) async {
      final dur = duration.value;
      if (dur.inSeconds > 0) {
        await AppStorage.addListenedLecture(dur.inSeconds);
        statsVersion.value++;
      }
      isPlaying.value = false;
      position.value = Duration.zero;
      currentId.value = null;
    });
  }

  static void init() {
    initAsync();
  }

  static Lecture? get currentLecture {
    final id = currentId.value;
    if (id == null) return null;
    try {
      return lecturesList.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<void> play(Lecture lecture) async {
    if (currentId.value == lecture.id) {
      if (isPlaying.value) {
        await player.pause();
      } else {
        await player.resume();
      }
      return;
    }

    currentId.value = lecture.id;
    position.value = Duration.zero;
    duration.value = Duration.zero;

    await player.stop();
    await player.play(AssetSource(lecture.path));

    try {
      _handler?.setMediaItem(MediaItem(
        id: lecture.path,
        title: lecture.title,
        album: 'خطب العلامة الشيخ محمد الإمام',
        artist: 'دار الحديث بمعبر',
      ));
    } catch (_) {}
  }

  static Future<void> toggle() async {
    if (currentId.value == null) return;
    if (isPlaying.value) {
      await player.pause();
    } else {
      await player.resume();
    }
  }

  static Future<void> seek(Duration d) => player.seek(d);

  static Future<void> forward10() async {
    await player.seek(position.value + const Duration(seconds: 10));
  }

  static Future<void> rewind10() async {
    final newPos = position.value - const Duration(seconds: 10);
    await player.seek(newPos.isNegative ? Duration.zero : newPos);
  }
}