# SleepHelper (Flutter)

Переписана з React Native (Expo) на Flutter версія застосунку SleepHelper2:
щоденник сну, калькулятор циклів сну, статистика якості на головному екрані.

## Запуск

У папці проєкту виконайте (один раз згенерує папки `android/`, `ios/`, `web/`):

```bash
flutter create --project-name sleep_helper --org com.example --platforms=android,ios,web .
flutter pub get
flutter run -d chrome      # або будь-який підключений пристрій: flutter run
```

Android Studio не обов’язкова: достатньо Flutter SDK, а запускати можна у Chrome
або на телефоні з увімкненим налагодженням по USB.

**Важливо для Android release-збірки.** Додайте дозвіл на інтернет у
`android/app/src/main/AndroidManifest.xml` (перед `<application>`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

(У debug-режимі він додається автоматично.)

## Відповідність старому коду

| React Native / Expo                       | Flutter                                   |
|-------------------------------------------|-------------------------------------------|
| Redux Toolkit (`sleepSlice`, `syncEntry`) | `lib/state/sleep_provider.dart` (Provider)|
| React Navigation (tabs + modal)           | `lib/screens/app_shell.dart` + bottom sheet `add_entry_sheet.dart` |
| `HomeScreen`, `DiaryScreen`, `CalcScreen` | `lib/screens/*_screen.dart`               |
| `utils/time.js`, `utils/sleepCycles.js`   | `lib/utils/time.dart`, `sleep_cycles.dart`|
| `theme.js`, `constants.js`                | `lib/theme.dart`, `lib/constants.dart`    |
| `@react-native-community/datetimepicker`  | `showTimePicker` (`lib/widgets/time_picker.dart`) |
| Ionicons                                  | Material Icons                            |

## Тести

```bash
flutter test
```
