# Groovy Inventory — Project Documentation

## Overview

**Groovy Inventory** is a cross-platform Flutter inventory management app for a factory. It connects to a FastAPI + MongoDB backend for managing raw transactions, stock movements, alerts, and reports.

- **Package name:** `groovy_inventory`
- **Version:** 1.0.0+1
- **Dart SDK:** ^3.12.0
- **State management:** riverpod  (per feature)
- **Routing:** `go_router` ^17.3.0
- **HTTP:** `dio` for API calls
- **Font:** SF Pro Display (custom, loaded globally)
- **Logging:** `logger` ^2.7.0
- **iOS UI enhancements:** `cupertino_native_better` ^1.5.0

---

## Architecture

Simple **feature-first** structure — no clean architecture, no domain/data/presentation layers, no use cases, no abstract repositories.

Each feature folder has these subfolders:

| Folder | Purpose |
|---|---|
| `screens/` | Full-page UI widgets (one per screen) |
| `widgets/` | Reusable widgets used only within this feature |
| `models/` | Dart classes for JSON parsing (fromJson/toJson) |
| `repository/` | API calls using Dio — one file per feature |
| `providers/` | State management (ChangeNotifier, StateNotifier, etc.) |

**Rules:**
- Keep it flat — no nested layers inside features
- Repository talks to the API, returns parsed models
- Providers hold state, call repository methods
- Screens read from providers, call provider methods
- Widgets are dumb UI components, no business logic
- Cross-feature shared code goes in `core/`

---

## Directory Structure

```
lib/
├── main.dart                              # App entry point
├── app/
│   ├── constants/
│   │   └── app_constants.dart             # App name, version, API base URL
│   ├── router/
│   │   ├── app_router.dart                # GoRouter config (all routes)
│   │   └── shell_scaffold.dart            # Bottom nav shell (iOS Liquid Glass + Android pill)
│   └── theme/
│       ├── app_colors.dart                # Color palette (primary: #81CC32)
│       └── app_theme.dart                 # Material 3 ThemeData + SF Pro Display font
├── core/
│   ├── network/
│   │   ├── api_client.dart                # Singleton Dio wrapper with JWT interceptor
│   │   └── api_response.dart              # Generic ApiResponse<T> matching backend format
│   ├── widgets/
│   │   ├── app_bar.dart                   # Shared app bar used across screens
│   │   ├── app_search_box.dart            # Shared debounced search field
│   │   └── material_picker_sheet.dart     # Reusable material selector bottom sheet
│   └── utils/
│       └── app_logger.dart                # Singleton logger (global `log` variable)
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   └── login_screen.dart          # Login form (email + password)
│   │   ├── models/                        # User model, login response, etc.
│   │   ├── repository/                    # Auth API calls (login, register, refresh)
│   │   ├── providers/                     # Auth state (token, current user)
│   │   └── widgets/                       # Auth-specific widgets
│   ├── dashboard/
│   │   ├── screens/
│   │   │   └── dashboard_screen.dart      # Overview cards, recent transactions
│   │   ├── models/
│   │   ├── repository/
│   │   ├── providers/
│   │   └── widgets/
│   ├── inventory/
│   │   ├── screens/
│   │   │   └── inventory_screen.dart      # Stock levels, transactions, alerts
│   │   ├── models/
│   │   ├── repository/
│   │   ├── providers/
│   │   └── widgets/
│   ├── transactions/
│   │   ├── screens/
│   │   │   └── transactions_screen.dart      # Material list, create/edit
│   │   ├── models/
│   │   ├── repository/
│   │   ├── providers/
│   │   └── widgets/
│   └── profile/
│       ├── screens/
│       │   └── profile_screen.dart        # User profile, settings
│       ├── models/
│       ├── repository/
│       ├── providers/
│       └── widgets/
```

---

## Adding a New Feature

1. Create `lib/features/<name>/` with subfolders: `screens/`, `models/`, `repository/`, `providers/`, `widgets/`
2. Add your screen, model, repo, and provider files
3. Register the route in `app_router.dart`
4. Add the tab in `shell_scaffold.dart` if it's a main nav item

---

## Routing

| Path | Screen | Nav |
|---|---|---|
| `/login` | `LoginScreen` | No bottom nav |
| `/dashboard` | `DashboardScreen` | Tab 1 |
| `/inventory` | `InventoryScreen` | Tab 2 |
| `/transactions` | `TransactionsScreen` | Tab 3 |
| `/profile` | `ProfileScreen` | Tab 4 |

- Login is outside ShellRoute (no bottom nav)
- All other screens are inside ShellRoute with bottom navigation

---

## Theming

- **Primary color:** `#81CC32` (green)
- **Design system:** Material 3 (`useMaterial3: true`)
- **Font:** SF Pro Display (all weights, globally applied)

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#81CC32` | Buttons, active nav, accents |
| `surface` | `#F9FAF0` | Background |
| `surfaceVariant` | `#E1E4D4` | Alternate backgrounds |
| `onSurface` | `#1A1C16` | Primary text |
| `onSurfaceVariant` | `#44483C` | Secondary text |
| `error` | `#BA1A1A` | Negative values, errors |
| `success` | `#2E7D32` | Positive values |

---

## API Client

Global Dio wrapper at `core/network/api_client.dart`:

```dart
import 'package:groovy_inventory/core/network/api_client.dart';

// Use the global instance
final response = await api.get<Map<String, dynamic>>(
  '/transactions',
  fromData: (json) => json as Map<String, dynamic>,
);

if (response.success) {
  // response.data has your parsed data
}
```

- Auto-attaches JWT Bearer token via interceptor
- Parses backend `{"success": bool, "message": string, "data": ...}` format
- Supports `get`, `post`, `put`, `patch`, `delete`

---

## Navigation

Bottom nav is platform-adaptive (`shell_scaffold.dart`):
- **iOS:** `CNTabBar` with SF Symbols and Liquid Glass
- **Android/others:** Floating pill-style nav with animated labels

Tabs: Dashboard, Inventory, Transactions, Profile

---

## Shared Widgets

Shared widgets that are reused across features live in `lib/core/widgets/`.

- `app_bar.dart` — app-wide custom app bar
- `app_search_box.dart` — reusable debounced search field. Use `AppSearchBox(onSearch: ...)` and update the screen-specific Riverpod search provider inside the callback.
- `material_picker_sheet.dart` — reusable material selector bottom sheet. Use `showMaterialPickerSheet(context)` to open it and receive a `MaterialModel?`.

---

## Dependencies

| Package | Purpose |
|---|---|
| `go_router` | Declarative routing |
| `dio` | HTTP client |
| `logger` | Debug logging |
| `cupertino_native_better` | iOS native tab bar |
| `cupertino_icons` | iOS icons |

---

## Backend

The app connects to a FastAPI + MongoDB backend. See `../Groovy-Inventory-Backend/` for:
- `CLAUDE.md` — Backend architecture and conventions
- `API_DOCS.md` — Complete API documentation (33 endpoints)

**API Base URL:** `http://192.168.1.9:8000/api/v1` (configured in `app_constants.dart`)

---

## Running

```bash
flutter pub get
flutter run
```

Starts on the login screen. The backend must be running for API calls to work.
