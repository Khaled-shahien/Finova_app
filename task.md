# Finova App Refactoring — Task Tracker

## Phase 1: Foundation — Dependencies
- [x] Update pubspec.yaml with go_router, firebase_auth, cloud_firestore, intl
- [x] Run flutter pub get

## Phase 2: Core Layer
- [x] Create core/models/ (transaction_model, budget_model, user_model)
- [x] Create core/routing/ (app_router, route_names)
- [x] Create core/services/ (auth_service, transaction_service, budget_service)
- [x] Create core/utils/ (date_formatter, icon_mapper)

## Phase 3: Feature Screens — Extract, Fix & Refactor
- [x] Rewrite main.dart (Firebase init, MaterialApp.router)
- [x] Extract onboarding_screen.dart (fix PageController bug)
- [x] Move & fix authentication_screen.dart (go_router, Firebase Auth)
- [x] Extract home_dashboard.dart (ShellRoute + bottom nav)
- [x] Extract home_screen.dart (add recent transactions, wire actions)
- [x] Move & fix add_transaction_screen.dart (AppBar fix, Firestore save)
- [x] Move & fix transactions_list_screen.dart (Firestore data)
- [x] Move & fix analytics_insights_screen.dart (fix _touchedIndex)
- [x] Move & fix budget_management_screen.dart (fix SliverGrid crash)
- [x] Move & fix profile_settings_screen.dart (logout, dark mode)
- [x] Update bottom_nav_bar.dart for go_router
- [x] Update app_bar.dart for go_router
- [x] Clean up old features/screens/ directory

## Phase 4: Verify
- [x] flutter analyze — clean
- [x] flutter build — compiles
- [x] Create completion report
