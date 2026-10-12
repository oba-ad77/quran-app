import 'package:flutter/material.dart';
import '../services/audio_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: AudioController.currentId,
      builder: (_, id, __) {
        if (id == null) return const SizedBox.shrink();
        final lecture = AudioController.currentLecture;
        if (lecture == null) return const SizedBox.shrink();
        return _buildCard(lecture.title);
      },
    );
  }

  Widget _buildCard(String title) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.mishkatGold.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 14,
            offset: const Offset(0, -2),
          ),
          BoxShadow(
            color: AppColors.mishkatGold.withValues(alpha: 0.12),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<Duration>(
            valueListenable: AudioController.position,
            builder: (_, pos, __) {
              return ValueListenableBuilder<Duration>(
                valueListenable: AudioController.duration,
                builder: (_, dur, __) {
                  final total = dur.inMilliseconds;
                  final cur = pos.inMilliseconds;
                  final p = total > 0 ? (cur / total).clamp(0.0, 1.0) : 0.0;
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: LinearProgressIndicator(
                      value: p,
                      minHeight: 3,
                      backgroundColor:
                          AppColors.mishkatGold.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.mishkatGold,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.mishkatGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.graphic_eq_rounded,
                    color: AppColors.mishkatGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 12,
                      color: AppColors.moonCream,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                _btn(
                  icon: Icons.forward_10_rounded,
                  onTap: AudioController.rewind10,
                  filled: false,
                ),
                const SizedBox(width: 6),
                ValueListenableBuilder<bool>(
                  valueListenable: AudioController.isPlaying,
                  builder: (_, playing, __) {
                    return _btn(
                      icon: playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      onTap: AudioController.toggle,
                      filled: true,
                    );
                  },
                ),
                const SizedBox(width: 6),
                _btn(
                  icon: Icons.replay_10_rounded,
                  onTap: AudioController.forward10,
                  filled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn({
    required IconData icon,
    required Future<void> Function() onTap,
    required bool filled,
  }) {
    return Material(
      color: filled
          ? AppColors.mishkatGold
          : AppColors.mishkatGold.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.all(filled ? 8 : 6),
          child: Icon(
            icon,
            color: filled ? AppColors.nightDeep : AppColors.mishkatGold,
            size: filled ? 22 : 18,
          ),
        ),
      ),
    );
  }
}