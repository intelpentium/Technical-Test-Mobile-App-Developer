import 'package:flutter/material.dart';

import '../../domain/entities/surah.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({
    required this.surah,
    required this.isSelected,
    required this.isPlaying,
    required this.onTap,
    super.key,
  });

  final Surah surah;
  final bool isSelected;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: isSelected ? const Color(0xFFEFFAF7) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? colorScheme.primary
                      : const Color(0xFFF3F4F6),
                ),
                child: Text(
                  surah.number.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            surah.englishName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          surah.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surah.englishNameTranslation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _MetaChip(
                          icon: Icons.menu_book_outlined,
                          label: '${surah.numberOfAyahs} ayahs',
                        ),
                        _MetaChip(
                          icon: Icons.mic_none,
                          label: surah.reciterName,
                        ),
                        _MetaChip(
                          icon: Icons.location_on_outlined,
                          label: surah.revelationType,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_outline,
                color: isSelected
                    ? colorScheme.primary
                    : const Color(0xFF6B7280),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: const Color(0xFF4B5563)),
        ),
      ],
    );
  }
}
