# MINI GAMER

An action-packed Flutter game featuring rockets, obstacles, and immersive sound effects. Test your reflexes as you navigate through challenging levels while collecting power-ups and avoiding hazards.

## Project Overview

**MINI GAMER** is a cross-platform mobile game built with Flutter, designed to deliver a fast-paced gaming experience on iOS, Android, and web platforms.

### Key Features
- 🎮 Engaging action gameplay with rocket mechanics
- 🔊 Dynamic sound effects and audio integration
- 📱 Cross-platform support (iOS, Android, Web, Linux, Windows, macOS)
- ⚡ Smooth animations and responsive controls
- 🎯 Progressive difficulty levels

### Tech Stack
- **Framework**: Flutter 3.5.0+
- **Language**: Dart
- **Audio**: AudioPlayers 6.5.1
- **State Management**: Flutter built-in
- **Assets**: Sound effects and visual assets

## Getting Started

### Prerequisites
- Flutter SDK (3.5.0 or higher)
- Dart SDK (included with Flutter)
- Platform-specific requirements:
  - **iOS**: Xcode 13+, iOS Deployment Target 12.0+
  - **Android**: Android SDK, Android Studio
  - **Web**: Chrome or compatible browser
  - **Linux/Windows/macOS**: Respective platform tools

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd minigamer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   
   # For Web
   flutter run -d web
   
   # For all devices
   flutter run
   ```

4. **Build for production**
   ```bash
   # Android APK
   flutter build apk
   
   # iOS IPA
   flutter build ios
   
   # Web
   flutter build web
   ```

## Project Structure

```
minigamer/
├── lib/
│   ├── main.dart           # App entry point
│   ├── app.dart            # App configuration
│   ├── core/
│   │   └── audio/          # Audio management utilities
│   └── features/
│       ├── game/           # Game logic and screens
│       └── menu/           # Menu and navigation screens
├── assets/
│   └── sounds/             # Game sound effects
├── android/                # Android platform code
├── ios/                    # iOS platform code
├── web/                    # Web platform code
├── linux/                  # Linux platform code
├── windows/                # Windows platform code
├── macos/                  # macOS platform code
├── test/                   # Unit and widget tests
├── pubspec.yaml            # Project dependencies
└── analysis_options.yaml   # Dart linting rules
```

## Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Code Formatting
```bash
dart format lib/
```

### Hot Reload
Press `r` in the terminal while running to perform hot reload, or `R` for hot restart.

## Contributing

Contributions are welcome! Please follow these guidelines:
1. Create a feature branch (`git checkout -b feature/your-feature`)
2. Commit your changes (`git commit -m 'Add some feature'`)
3. Push to the branch (`git push origin feature/your-feature`)
4. Open a Pull Request

## Version History

- **v1.0.0** - Initial release
  - Core gameplay mechanics
  - Audio integration
  - Multi-platform support

## Troubleshooting

### Common Issues

**Issue**: Pods not found for iOS
```bash
cd ios
rm -rf Pods
pod install
cd ..
flutter pub get
```

**Issue**: Build cache issues
```bash
flutter clean
flutter pub get
flutter run
```

**Issue**: Audio not playing
- Ensure audio files are in `assets/sounds/`
- Check that assets are configured in `pubspec.yaml`
- Verify AudioPlayers plugin is properly initialized

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [AudioPlayers Package](https://pub.dev/packages/audioplayers)
- [Flutter Best Practices](https://docs.flutter.dev/development/best-practices)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or suggestions, please open an issue in the repository.
