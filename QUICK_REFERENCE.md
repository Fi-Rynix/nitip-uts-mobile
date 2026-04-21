# 🚀 E-Ticketing Helpdesk - Quick Reference Guide

## ⚡ Quick Start

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk --release
```

---

## 🔑 Test Credentials

| Role | Username | Password |
|------|----------|----------|
| User | user1 | password |
| User | user2 | password |
| Admin | admin | admin123 |

---

## 🗺️ Route Shortcuts

```dart
// Navigate to dashboard
Navigator.pushNamed(context, '/dashboard');

// Navigate to tickets
Navigator.pushNamed(context, '/tickets');

// Navigate to ticket detail with ID
Navigator.pushNamed(context, '/ticket_detail', arguments: 'ticket_123');

// Navigate to create ticket
Navigator.pushNamed(context, '/create_ticket');

// Navigate to notifications
Navigator.pushNamed(context, '/notification');

// Navigate to settings
Navigator.pushNamed(context, '/settings');
```

---

## 🧠 State Management Cheat Sheet

### Watch Provider (Rebuild on Change)
```dart
final value = ref.watch(someProvider);
```

### Read Provider (One-time Read)
```dart
final value = ref.read(someProvider);
```

### Update State
```dart
ref.read(stateProvider.notifier).state = newValue;
```

### Refresh Provider
```dart
ref.refresh(dataProvider);
```

### FutureProvider
```dart
final dataAsync = ref.watch(dataProvider);
return dataAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => ErrorWidget(),
  data: (data) => DataWidget(),
);
```

---

## 🎨 Color & Theme

### Theme Access
```dart
// Light theme
Theme.of(context).colorScheme.primary

// Dark theme
Theme.of(context).colorScheme.inversePrimary

// Background
Theme.of(context).scaffoldBackgroundColor
```

### Dark Mode Toggle
```dart
// In Settings page
ref.read(themeModeProvider.notifier).state = !isDarkMode;
```

---

## 📸 Camera Permission

### Check Permission
```dart
final hasPermission = await CameraService().isCameraPermissionGranted();
```

### Request Permission
```dart
final granted = await CameraService().requestCameraPermission();
```

### Permission Provider
```dart
final permission = ref.watch(cameraPermissionProvider);
```

---

## 📁 File Locations

| Component | Path |
|-----------|------|
| Routes | `lib/core/constants/app_constants.dart` |
| Router | `lib/core/router/app_router.dart` |
| Theme | `lib/core/theme/` |
| Auth | `lib/features/auth/` |
| Tickets | `lib/features/ticket/` |
| Dashboard | `lib/features/dashboard/` |
| Settings | `lib/features/settings/` |
| Models | `lib/features/*/data/models/` |
| Repositories | `lib/features/*/data/repositories/` |
| Providers | `lib/features/*/presentation/providers/` |
| Pages | `lib/features/*/presentation/pages/` |

---

## 🧪 Common Testing Scenarios

### Test Login
1. Open app → Click on login page
2. Enter: user1 / password
3. Expected: Dashboard with user view
4. Check: Ticket count shows 2

### Test Admin Access
1. Login as admin / admin123
2. Expected: Dashboard with admin statistics
3. Check: Can see all 5 tickets
4. Check: Can assign & change status buttons visible

### Test Ticket Detail
1. Click on any ticket from list
2. Expected: Detail page opens with all info
3. Verify: Status, comments, assigned to visible

### Test Create Ticket
1. From ticket list tap "+" button
2. Enter title & description
3. Tap camera button
4. Expected: Permission dialog OR camera screen
5. Complete form & submit
6. Verify: New ticket appears in list

### Test Dark Mode
1. Go to Settings
2. Toggle "Dark Mode"
3. Expected: Colors change
4. Verify: Persists on other pages

### Test Navigation
1. Tap each bottom nav item
2. Expected: Smooth transitions
3. Verify: Correct page content
4. Test back button on each page

---

## 🔧 Development Tips

### Hot Reload
Press `r` in terminal while running

### Hot Restart
Press `R` in terminal while running

### Clean Build
```bash
flutter clean && flutter pub get && flutter run
```

### Debug Print
```dart
debugPrint('Debug message');
```

### Inspect Widget Tree
```bash
# Open DevTools
flutter pub global run devtools
```

### Profile App Performance
```bash
flutter run --profile
```

### Check Device Info
```bash
flutter devices
```

---

## ⚠️ Common Issues

| Issue | Solution |
|-------|----------|
| Route not found | Check AppConstants & AppRouter |
| Provider not updating | Use `watch` not `read` |
| Permission denied | Rebuild app & check manifest |
| Dark mode not saving | Implement SharedPreferences |
| Camera permission error | Check Info.plist & AndroidManifest |
| Build fails | Run `flutter clean && flutter pub get` |

---

## 📋 Checklist for New Features

- [ ] Create feature folder in `features/`
- [ ] Add `data/models/` with model class
- [ ] Add `data/repositories/` with business logic
- [ ] Add `presentation/pages/` with UI
- [ ] Add `presentation/providers/` with state
- [ ] Add route to `AppConstants`
- [ ] Add route handler in `AppRouter`
- [ ] Test navigation
- [ ] Update documentation

---

## 🎯 Project Status

```
✅ Setup complete
✅ All models created
✅ Riverpod providers setup
✅ Authentication system
✅ Dashboard (role-based)
✅ Ticket management
✅ Camera permission
✅ Navigation & routing
✅ Dark mode
✅ Notifications
✅ Documentation
```

---

## 📞 Support & Debug

### Enable Verbose Logging
```bash
flutter run -v
```

### Check Flutter Doctor
```bash
flutter doctor
```

### Version Info
```bash
flutter --version
dart --version
```

### Emulator Control
```bash
# List emulators
emulator -list-avds

# Start emulator
emulator -avd <emulator_name>

# iOS Simulator
open -a Simulator
```

---

## 📚 Quick Links

- 📖 Full Documentation: See `DOCUMENTATION.md`
- 🎯 Project Brief: See `brief.md`
- 💻 GitHub: Add your repo URL here
- 📱 Flutter Docs: https://flutter.dev/docs

---

**Last Updated:** April 21, 2026
**For:** E-Ticketing Helpdesk Flutter App v1.0.0
