# 📱 E-Ticketing Helpdesk Flutter App - Complete Documentation

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure)
4. [Setup & Installation](#setup--installation)
5. [Architecture](#architecture)
6. [Features](#features)
7. [Authentication System](#authentication-system)
8. [Navigation & Routing](#navigation--routing)
9. [Camera Permission](#camera-permission)
10. [State Management](#state-management)
11. [Data Models](#data-models)
12. [Running the App](#running-the-app)
13. [Testing](#testing)
14. [Troubleshooting](#troubleshooting)

---

## 📱 Project Overview

**E-Ticketing Helpdesk** adalah aplikasi mobile Flutter untuk simulasi sistem ticketing helpdesk dengan fitur:
- ✅ Role-based UI (User & Admin)
- ✅ Ticket management (create, list, detail, comment)
- ✅ Camera permission & photo capture simulation
- ✅ Dark mode support
- ✅ Notifications
- ✅ Dummy data (no backend required)

**Tujuan Pembelajaran:**
- UI/UX Design dengan Flutter
- Navigation & Routing
- State Management dengan Riverpod
- Role-based rendering
- Permission handling

---

## ⚙️ Tech Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | UI Framework |
| **Dart** | Programming Language |
| **Riverpod** | State Management |
| **permission_handler** | Camera Permission |
| **shared_preferences** | Local Storage (optional) |

**Minimum Requirements:**
- Flutter 3.11.0+
- Dart 3.0.0+
- Android 5.0+ (API 21)
- iOS 11.0+

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App Entry Point
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # App-wide constants & routes
│   ├── router/
│   │   └── app_router.dart            # Routing configuration
│   ├── theme/
│   │   ├── app_theme.dart             # Light & Dark themes
│   │   └── theme_provider.dart        # Theme state (Riverpod)
│   ├── services/
│   │   └── camera_service.dart        # Camera permission handler
│   └── widgets/
│       └── common_widget.dart          # Reusable widgets
│
├── features/
│   │
│   ├── auth/                           # Authentication Feature
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── splash_screen.dart
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── reset_password_screen.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   │
│   ├── dashboard/                     # Dashboard Feature
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── main_layout.dart
│   │       │   └── dashboard_page.dart
│   │       └── widgets/
│   │           ├── dashboard_user_widget.dart
│   │           └── dashboard_admin_widget.dart
│   │
│   ├── ticket/                        # Ticket Management Feature
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── ticket_model.dart
│   │   │   │   ├── comment_model.dart
│   │   │   │   └── technician_model.dart
│   │   │   └── repositories/
│   │   │       ├── ticket_repository.dart
│   │   │       └── technician_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── ticket_list_page.dart
│   │       │   ├── ticket_detail_page.dart
│   │       │   ├── create_ticket_page.dart
│   │       │   └── camera_screen.dart
│   │       └── providers/
│   │           ├── ticket_provider.dart
│   │           └── camera_provider.dart
│   │
│   ├── notification/                  # Notification Feature
│   │   └── presentation/
│   │       └── pages/
│   │           └── notification_page.dart
│   │
│   └── settings/                      # Settings Feature
│       └── presentation/
│           └── pages/
│               └── settings_page.dart
│
pubspec.yaml                            # Dependencies
android/
├── app/src/main/
│   ├── AndroidManifest.xml             # Android config (with CAMERA permission)
│   └── kotlin/
└── ...
ios/
├── Runner/
│   ├── Info.plist                      # iOS config (with NSCameraUsageDescription)
│   └── ...
└── ...
```

---

## 🚀 Setup & Installation

### 1. **Clone/Open Project**
```bash
cd e:\Project\ Flutter\uts_mobile
```

### 2. **Get Dependencies**
```bash
flutter pub get
```

### 3. **Run the App**
```bash
# Development mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>
```

### 4. **Build APK (Android)**
```bash
flutter build apk --release
```

### 5. **Build IPA (iOS)**
```bash
flutter build ios --release
```

---

## 🏗️ Architecture

Project menggunakan **Simplified Clean Architecture** dengan 3 layer:

### **1. Data Layer** (`data/`)
```
├── models/          # Data models (Ticket, User, Comment, etc)
└── repositories/    # Business logic & data handling
```

**Repositories** menangani:
- Dummy data generation
- Login validation
- Ticket CRUD operations
- Role-based data filtering

### **2. Presentation Layer** (`presentation/`)
```
├── pages/           # Full screens
├── widgets/         # Reusable UI components
└── providers/       # Riverpod state management
```

**Pages** bertanggung jawab:
- Rendering UI
- User interactions
- Navigation triggers

### **3. Core Layer** (`core/`)
```
├── constants/       # App-wide constants
├── router/          # Routing configuration
├── theme/           # UI themes
├── services/        # Platform services (camera)
└── widgets/         # Global reusable widgets
```

### **Flow Diagram**
```
UI (Pages/Widgets)
    ↓
Riverpod Providers (State Management)
    ↓
Repositories (Business Logic)
    ↓
Models (Data Structure)
```

---

## ✨ Features

### 1. **Authentication** 🔐
- Login dengan username/password
- Register form (UI only)
- Reset password (UI only)
- Role-based access control

**Test Credentials:**
```
User 1:
  Username: user1
  Password: password
  Role: user

User 2:
  Username: user2
  Password: password
  Role: user

Admin:
  Username: admin
  Password: admin123
  Role: admin
```

### 2. **Dashboard** 📊
**User View:**
- Total tickets count
- Active tickets count

**Admin View:**
- Total tickets count
- Tickets by status (open, assigned, in progress, done, cancelled)

### 3. **Ticket Management** 🎟
**List View:**
- Filter by status (All, Open, Assigned, In Progress, Done, Cancelled)
- User hanya melihat ticket mereka sendiri
- Admin melihat semua tickets
- Admin bisa assign ke technician & change status

**Detail View:**
- View ticket info (title, description, status, creator, dates)
- Status tracking timeline
- Comments section
- Admin: assign technician dropdown
- Both: add comments

**Create Ticket:**
- Title & description input
- Camera button (with permission handling)
- Submit button

### 4. **Camera Permission** 📸
- Request CAMERA permission
- Permission status handling (granted/denied/permanently denied)
- Settings redirection
- Dummy camera preview screen
- "Take Photo" simulation

### 5. **Notifications** 🔔
- Dummy notification list
- Click to navigate to ticket detail

### 6. **Settings** ⚙️
- Dark mode toggle
- Logout functionality
- App information

### 7. **Theme** 🌙
- Light mode (default)
- Dark mode
- Persistent storage (optional)

---

## 🔐 Authentication System

### Login Flow
```
1. User input username & password
2. Validate against predefined credentials (auth_repository.dart)
3. If valid:
   - Set current user in Riverpod state
   - Save user role
   - Navigate to Dashboard
4. If invalid:
   - Show error message
```

### Role System
- **User Role:** Melihat hanya ticket mereka, bisa add comments
- **Admin Role:** Melihat semua tickets, bisa assign & change status

### Predefined Users
Located in: `lib/features/auth/data/repositories/auth_repository.dart`

---

## 🗺️ Navigation & Routing

### Route Constants
Defined in: `lib/core/constants/app_constants.dart`

```dart
static const String routeSplash = '/';
static const String routeLogin = '/login';
static const String routeRegister = '/register';
static const String routeDashboard = '/dashboard';
static const String routeTicketList = '/tickets';
static const String routeTicketDetail = '/ticket_detail';
static const String routeCreateTicket = '/create_ticket';
static const String routeNotification = '/notification';
```

### Router Implementation
Location: `lib/core/router/app_router.dart`

**Features:**
- ✅ Named routes
- ✅ Argument passing (e.g., ticket ID)
- ✅ onGenerateRoute for dynamic routing
- ✅ Fallback for undefined routes

### Navigation Example
```dart
// Simple navigation
Navigator.pushNamed(context, AppConstants.routeDashboard);

// Navigation with arguments
Navigator.pushNamed(
  context,
  AppConstants.routeTicketDetail,
  arguments: ticketId,
);

// Pop navigation
Navigator.pop(context);
```

---

## 📸 Camera Permission

### Android Setup
**File:** `android/app/src/main/AndroidManifest.xml`

✅ CAMERA permission sudah ditambahkan:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### iOS Setup
**File:** `ios/Runner/Info.plist`

✅ NSCameraUsageDescription sudah ditambahkan:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to allow you to attach photos to your tickets</string>
```

### Permission Flow
```
1. User click "Attach Photo" button
2. Request camera permission via permission_handler
3. Handle status:
   - Granted: Navigate to camera screen
   - Denied: Show snackbar
   - Permanently Denied: Show dialog + settings button
4. Camera screen (dummy):
   - Show fake camera preview
   - Take Photo button (simulated)
   - Cancel button
```

### Permission Service
Location: `lib/core/services/camera_service.dart`

Methods:
- `requestCameraPermission()` - Request permission
- `getCameraPermissionStatus()` - Get current status
- `isCameraPermissionGranted()` - Check if granted
- `openAppSettings()` - Open app settings

---

## 🔄 State Management

### Riverpod Providers

#### 1. **Auth Provider** 
Location: `lib/features/auth/presentation/providers/auth_provider.dart`

```dart
// Current logged-in user
final currentUserProvider = StateProvider<User?>((ref) => null);

// Current user role
final currentRoleProvider = StateProvider<String?>((ref) => null);
```

#### 2. **Theme Provider**
Location: `lib/core/theme/theme_provider.dart`

```dart
// Dark mode toggle
final themeModeProvider = StateProvider<bool>((ref) => false);
```

#### 3. **Ticket Provider**
Location: `lib/features/ticket/presentation/providers/ticket_provider.dart`

```dart
// All tickets
final allTicketsProvider = Provider<List<Ticket>>((ref) => []);

// User's tickets
final userTicketsProvider = Provider<List<Ticket>>((ref) => []);

// Single ticket detail
final ticketDetailProvider = FutureProvider<Ticket?>((ref) => null);
```

#### 4. **Camera Provider**
Location: `lib/features/ticket/presentation/providers/camera_provider.dart`

```dart
// Camera service instance
final cameraServiceProvider = Provider<CameraService>((ref) => CameraService());

// Camera permission status
final cameraPermissionProvider = FutureProvider<bool>((ref) async => false);
```

### Provider Usage Example
```dart
// Watch provider (rebuild on change)
final user = ref.watch(currentUserProvider);

// Read provider (one-time read)
final user = ref.read(currentUserProvider);

// Mutate provider (change state)
ref.read(currentUserProvider.notifier).state = newUser;
```

---

## 📦 Data Models

### User Model
```dart
class User {
  String username;
  String password;
  String role;        // "user" or "admin"
  DateTime? lastLogin;
}
```

### Ticket Model
```dart
class Ticket {
  String id;
  String title;
  String description;
  String status;       // "open", "assigned", "in_progress", "done", "cancelled"
  String createdBy;    // username
  String? assignedTo;  // technician username
  DateTime createdAt;
  List<Comment> comments;
}
```

### Comment Model
```dart
class Comment {
  String id;
  String author;       // username
  String content;
  DateTime createdAt;
}
```

### Technician Model
```dart
class Technician {
  String id;
  String name;
  String username;
}
```

---

## 🎮 Running the App

### Development Mode
```bash
flutter run
```

### Debug Prints
```dart
// Add to see debug info
debugPrint('Message');
```

### Hot Reload
- Press `r` in terminal
- Or click Hot Reload in IDE

### Hot Restart
- Press `R` in terminal
- Full app restart

### Build & Run
```bash
# Build for Android
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Build for iOS
flutter build ios --release
# Output: build/ios/iphoneos/Runner.app
```

---

## 🧪 Testing

### Manual Test Scenarios

#### 1. **Login Flow**
```
1. Start app → Splash screen
2. Auto redirect to login (no saved session)
3. Enter user1/password
4. Should redirect to dashboard (user view)
5. Verify: Total tickets = 2
```

#### 2. **Role-Based UI**
```
1. Login as user1
2. Check: Can see own tickets only (2)
3. Check: Cannot assign/change status
4. Logout
5. Login as admin
6. Check: Can see all tickets (5)
7. Check: Can assign & change status
```

#### 3. **Ticket Detail**
```
1. Login as user1
2. Tap on ticket
3. Should show detail page with:
   - Ticket info
   - Status timeline
   - Comments section
4. Try add comment
5. Check: Comment appears immediately
```

#### 4. **Create Ticket**
```
1. From ticket list, tap "Create"
2. Fill title & description
3. Tap "Attach Photo"
4. Grant/deny permission
5. If granted: Camera screen should open
6. Click "Take Photo"
7. Return to create ticket page
8. Submit ticket
9. Should appear in ticket list
```

#### 5. **Camera Permission**
```
Test Case 1: Permission Granted
1. Tap camera button
2. Grant permission
3. Camera screen opens ✓

Test Case 2: Permission Denied
1. Tap camera button
2. Deny permission
3. Snackbar shows "Camera permission denied" ✓

Test Case 3: Permission Permanently Denied
1. (Must revoke permission from settings first)
2. Tap camera button
3. Dialog shows with "Open Settings" button
4. Tap button → App settings open ✓
```

#### 6. **Dark Mode**
```
1. Go to Settings
2. Toggle "Dark Mode"
3. Verify: Theme changes
4. Go to different screens
5. Verify: Dark theme persists
```

#### 7. **Navigation**
```
1. Test all bottom nav items
2. Test back button
3. Test page transitions smooth
4. Test no memory leaks (use profiler)
```

---

## 🐛 Troubleshooting

### Issue: Camera Permission Not Working

**Problem:** "Permission denied" even after granting

**Solutions:**
1. Rebuild app (flutter clean && flutter run)
2. Uninstall and reinstall app
3. Check AndroidManifest.xml has `<uses-permission>` tag
4. Check iOS Info.plist has NSCameraUsageDescription
5. For iOS: Check Xcode capabilities

### Issue: Route Not Found

**Problem:** "Route not found: /some_route"

**Solutions:**
1. Check route name is correct in AppConstants
2. Check route is added in AppRouter.onGenerateRoute
3. Use named routes from AppConstants
4. Check for typos

### Issue: Provider Not Updating

**Problem:** UI doesn't update when state changes

**Solutions:**
1. Use `ref.watch()` not `ref.read()`
2. Rebuild parent widget
3. Check provider is wrapped in ProviderScope
4. Check state mutation is correct

### Issue: Dark Mode Not Persisting

**Problem:** Dark mode resets on app restart

**Solutions:**
1. Implement SharedPreferences saving
2. Save theme preference on toggle
3. Load preference on app start
4. Add to main() function initialization

### Issue: Camera Screen Shows Dummy View

**This is expected!** The app is designed with dummy camera preview because:
- No actual camera package integration required
- Focuses on UI/UX and permission handling
- Simplifies testing and learning

To add real camera:
1. Add `camera` package
2. Replace dummy view with CameraPreview
3. Add image capture logic
4. Update file handling

### Issue: App Crashes on Startup

**Problem:** Crash with "ProviderScope not found"

**Solutions:**
1. Check main.dart has `ProviderScope(child: MyApp())`
2. Check all imports are correct
3. Run: `flutter clean && flutter pub get`
4. Check for circular imports

---

## 📝 Development Tips

### Adding New Feature
1. Create feature folder in `lib/features/`
2. Add `data/` and `presentation/` folders
3. Create models in `data/models/`
4. Create repository in `data/repositories/`
5. Create pages in `presentation/pages/`
6. Create providers in `presentation/providers/`
7. Add routes to AppRouter
8. Update AppConstants routes if needed

### Best Practices
✅ Use named routes from AppConstants
✅ Use Riverpod for state management
✅ Keep business logic in repositories
✅ Keep UI logic in pages/widgets
✅ Use proper null safety
✅ Handle errors gracefully
✅ Add loading states
✅ Use proper type checking

### Common Patterns

**Fetch Data Pattern:**
```dart
final dataAsync = ref.watch(dataProvider);
return dataAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
  data: (data) => ListView(children: ...),
);
```

**Update State Pattern:**
```dart
// Update state
ref.read(stateProvider.notifier).state = newValue;

// Refresh provider
ref.refresh(dataProvider);
```

---

## 📚 Additional Resources

### Flutter Documentation
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)

### Riverpod
- [Riverpod Docs](https://riverpod.dev)

### Permission Handler
- [permission_handler](https://pub.dev/packages/permission_handler)

### Project Files Location
- Models: `lib/features/*/data/models/`
- Repositories: `lib/features/*/data/repositories/`
- Pages: `lib/features/*/presentation/pages/`
- Providers: `lib/features/*/presentation/providers/`
- Constants: `lib/core/constants/`
- Router: `lib/core/router/`
- Theme: `lib/core/theme/`
- Services: `lib/core/services/`

---

## 🎓 Learning Outcomes

Setelah menyelesaikan project ini, Anda akan memahami:

✅ Flutter UI/UX Design
✅ Navigation & Deep Linking
✅ State Management (Riverpod)
✅ Clean Architecture
✅ Permission Handling
✅ Role-based Access Control
✅ Async Programming
✅ Error Handling
✅ Testing Strategies
✅ Best Practices

---

## 📄 Summary

| Aspect | Status |
|--------|--------|
| Project Structure | ✅ Complete |
| All Models | ✅ Complete |
| Riverpod Providers | ✅ Complete |
| Authentication | ✅ Complete |
| Dashboard (Role-based) | ✅ Complete |
| Ticket Management | ✅ Complete |
| Camera Permission | ✅ Complete |
| Navigation & Routing | ✅ Complete |
| Dark Mode | ✅ Complete |
| Notifications | ✅ Complete |
| Documentation | ✅ Complete |

---

**Last Updated:** April 21, 2026
**Version:** 1.0.0
**Status:** Ready for Development & Learning
