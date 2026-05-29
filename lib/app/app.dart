import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../features/quran_player/data/datasources/quran_remote_datasource.dart';
import '../features/quran_player/data/repositories/quran_repository_impl.dart';
import '../features/quran_player/domain/repositories/quran_repository.dart';
import '../features/quran_player/domain/usecases/get_surah_audio.dart';
import '../features/quran_player/domain/usecases/get_surahs.dart';
import '../features/quran_player/presentation/cubit/player_cubit.dart';
import '../features/quran_player/presentation/cubit/quran_cubit.dart';
import '../features/quran_player/presentation/pages/quran_player_page.dart';

class QuranRecitationApp extends StatelessWidget {
  const QuranRecitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<http.Client>(
          create: (_) => http.Client(),
          dispose: (client) => client.close(),
        ),
        RepositoryProvider<QuranRemoteDataSource>(
          create: (context) =>
              QuranRemoteDataSourceImpl(client: context.read<http.Client>()),
        ),
        RepositoryProvider<QuranRepository>(
          create: (context) => QuranRepositoryImpl(
            remoteDataSource: context.read<QuranRemoteDataSource>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                QuranCubit(GetSurahs(context.read<QuranRepository>()))
                  ..loadSurahs(),
          ),
          BlocProvider(
            create: (context) =>
                PlayerCubit(GetSurahAudio(context.read<QuranRepository>())),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Quran Recitation Player',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F766E),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF7F8FA),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF111827),
              surfaceTintColor: Colors.white,
              elevation: 0.5,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0F766E)),
              ),
            ),
          ),
          home: const QuranPlayerPage(),
        ),
      ),
    );
  }
}
