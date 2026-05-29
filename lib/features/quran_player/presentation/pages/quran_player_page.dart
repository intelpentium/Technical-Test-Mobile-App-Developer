import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/player_cubit.dart';
import '../cubit/player_state.dart';
import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';
import '../widgets/player_controls.dart';
import '../widgets/search_input.dart';
import '../widgets/surah_tile.dart';

class QuranPlayerPage extends StatelessWidget {
  const QuranPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedSurahNumber = context.select(
      (PlayerCubit cubit) => cubit.state.selectedSurah?.number,
    );
    final playerStatus = context.select(
      (PlayerCubit cubit) => cubit.state.status,
    );

    return BlocListener<PlayerCubit, PlayerState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage &&
            current.status == PlayerStatus.error &&
            current.errorMessage != null;
      },
      listener: (context, state) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Quran Recitation Player')),
        body: Column(
          children: [
            BlocBuilder<QuranCubit, QuranState>(
              buildWhen: (previous, current) => previous.query != current.query,
              builder: (context, state) {
                return SearchInput(
                  query: state.query,
                  onChanged: context.read<QuranCubit>().search,
                );
              },
            ),
            Expanded(
              child: BlocBuilder<QuranCubit, QuranState>(
                builder: (context, state) {
                  switch (state.status) {
                    case QuranStatus.initial:
                    case QuranStatus.loading:
                      return const Center(child: CircularProgressIndicator());
                    case QuranStatus.error:
                      return _ErrorState(
                        message:
                            state.errorMessage ??
                            'Failed to load Quran data. Please try again.',
                        onRetry: context.read<QuranCubit>().loadSurahs,
                      );
                    case QuranStatus.loaded:
                      if (state.filteredSurahs.isEmpty) {
                        return const _EmptyState();
                      }

                      return RefreshIndicator(
                        onRefresh: context.read<QuranCubit>().loadSurahs,
                        child: ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          itemCount: state.filteredSurahs.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final surah = state.filteredSurahs[index];
                            final isSelected =
                                selectedSurahNumber == surah.number;

                            return SurahTile(
                              surah: surah,
                              isSelected: isSelected,
                              isPlaying:
                                  isSelected &&
                                  playerStatus == PlayerStatus.playing,
                              onTap: () {
                                context.read<PlayerCubit>().selectSurah(surah);
                              },
                            );
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<PlayerCubit, PlayerState>(
          builder: (context, state) {
            return PlayerControls(
              state: state,
              onPlayPause: context.read<PlayerCubit>().togglePlayPause,
              onSeek: context.read<PlayerCubit>().seek,
              onStop: context.read<PlayerCubit>().stop,
            );
          },
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 40),
            const SizedBox(height: 12),
            Text(
              'No recitation found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
