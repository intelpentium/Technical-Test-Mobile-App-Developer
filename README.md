# Quran Recitation Player

## Overview

Quran Recitation Player is a Flutter mobile app for browsing surah recitation tracks from Al Quran Cloud and playing a simple audio preview using Mishary Alafasy as the default reciter.

The technical test mentions songs and artists. Since the required public API is Al Quran Cloud, this app maps songs to Quran recitation tracks and artists to reciters.

## Features

- Search surah by title/name, translation, Arabic name, or default reciter
- Play Quran recitation audio from Al Quran Cloud
- Pause and resume playback
- Display current position and total duration
- Seek audio using a slider
- Retry UI for API failures
- State management with BLoC/Cubit
- Clean and organized project structure

## Tech Stack

- Flutter 3.35.3
- Dart 3.9.2
- BLoC/Cubit via `flutter_bloc`
- Al Quran Cloud API
- `just_audio`
- `http`

## API Reference

- `GET https://api.alquran.cloud/v1/surah`
- `GET https://api.alquran.cloud/v1/surah/{number}/ar.alafasy`

The app uses the surah list endpoint for local search data. When a user selects a surah, the app fetches the Alafasy audio edition and plays the first available ayah audio as the recitation preview.

## Project Structure

```text
lib/
  app/
    app.dart
  core/
    constants/
    error/
    utils/
  features/
    quran_player/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        cubit/
        pages/
        widgets/
```

## How to Run

Flutter SDK is configured on this machine at:

```text
/Users/fathurrahman/Documents/Fathur/Tools/flutter_macos_3.35.3-stable
```

Android SDK is configured at:

```text
/Users/fathurrahman/Documents/Fathur/Tools/SDK_Android_Studio
```

Run from this project folder:

```bash
flutter pub get
flutter run
```

For Android Studio:

1. Open this project folder.
2. Use the Flutter SDK path above if Android Studio asks for it.
3. Select an Android emulator or connected Android device.
4. Run `lib/main.dart`.

## How to Test

```bash
flutter test
```

Included tests cover duration formatting, surah search filtering, the search field, and the player play button.

## Screenshots

Add screenshots in:

```text
docs/screenshots/
```

Recommended files:

```md
[Home Screen](docs/screenshots/home.png)
[Player Screen](docs/screenshots/player.png)
[Search Screen](docs/screenshots/search.png)
```

## Notes

- `song` = Quran recitation track.
- `artist` = reciter.
- Default reciter = Mishary Alafasy.
- Current playback strategy uses the first available ayah audio from the selected surah as a stable preview track.
- Android Internet permission is enabled for API and audio streaming.

## Future Improvements

- Playlist playback for the full surah
- Favorite recitations
- Offline caching
- More reciters
- Dark mode
- Custom app icon
