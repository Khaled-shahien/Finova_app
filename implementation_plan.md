# Finova App — Full Audit & Refactor Implementation Plan

## Audit Summary

After inspecting the entire codebase, design assets (8 screen designs + 1 design system doc), `rules.md`, Firebase config, and all source files, here are the key findings:

### Critical Issues Found

> [!CAUTION]
> **Home Dashboard is significantly different from design.** The current home screen is missing:
> - "Good Morning Khaled" greeting header with profile avatar
> - Monthly Summary card (Income/Expenses breakdown)
> - Weekly Spending bar chart
> - "Add Expense" quick action (only has "Add Income" + "View Ledger")
> - "View All" button on Recent Activity section
> - "+12.5% Since last month" trend badge on balance card
> - The balance card lacks the blob background pattern

> [!CAUTION]
> **Transactions list screen is significantly different from design.** Missing:
> - "LEDGER" overline label + large "Transactions" headline
> - Date group headers ("Today JAN 24, 2024" / "Yesterday JAN 23, 2024")
> - The top bar with profile avatar + "The Financial Atelier" branding
> - Search placeholder says "Search merchant or category..." in design

> [!WARNING]
> **Onboarding screen deviates from design.** Design shows image-based illustration cards with overlaid spending/income mini-cards. Current implementation uses plain icon containers.

> [!WARNING]
> **Architecture issues:** All screens live in a flat `features/screens/` folder instead of being organized by feature with data/domain/presentation layers.

### UI Issues by Screen
1. **Home Dashboard**: Missing Monthly Summary card, Weekly Spending chart, Add Expense action, greeting header, trend badge
2. **Transactions List**: Missing "LEDGER" overline, date group headers, branded top bar
3. **Onboarding**: Uses plain icons instead of rich illustration cards from design
4. **Analytics**: Pie chart center should show "TOTAL SPENT $4,280" text
5. **Budget Management**: Mostly matches ✓
6. **Profile Settings**: Mostly matches ✓
7. **Authentication**: Mostly matches ✓ (minor: "Back to onboarding" button not in design)
8. **Add Transaction**: Mostly matches ✓

### Architecture Issues
- Flat `features/screens/` folder — no feature-based organization
- No separation of presentation/domain/data per feature
- Services are singletons with tight coupling (no DI)
- Missing `core/constants/` directory
- Missing `core/errors/` directory
- `design_assets` folder is inside `lib/` (should not be compiled)
- Duplicate bottom nav handling across multiple screens (analytics, budget, profile each handle nav manually instead of relying on the shell route)

### Bug & Code Quality Issues
- `authentication_screen.dart` line 380: catches `FirebaseAuthException` which doesn't exist — should be `FirebaseAuthException` → actually need to check the correct class
- `add_transaction_screen.dart`: Has a duplicate `EditorialBottomNavBar` in its `bottomNavigationBar` but is also rendered inside `StatefulShellRoute` which already has one — double bottom nav bar
- `home_screen.dart` line 154: Hardcoded balance `$42,850.40` — should compute from transactions
- Multiple screens have helper methods returning widgets (`_buildMobileBrand()`, `_buildFormCard()`, etc.) instead of private Widget classes (rules.md violation)
- `profile_settings_screen.dart`: Not inside the `StatefulShellRoute`, so bottom nav doesn't integrate with shell state
- `DateFormatter` utility exists but is not used — screens duplicate date formatting logic
- `UserModel` exists but is never used
- `BudgetCategoryCard` in `cards.dart` is never used

### Firebase Observations
- Firebase Core + Auth + Firestore properly configured for Android/iOS ✓
- `firebase_options.dart` present with API keys for Android/iOS ✓
- `google-services.json` referenced in `firebase.json` ✓
- Web/macOS/Windows/Linux not configured (acceptable for mobile-only project)
- Missing error handling wrapper/Firebase error utilities

### Rules.md Compliance Issues
- Uses Google Fonts ✓
- Uses `go_router` ✓
- Uses `StreamBuilder` for data ✓
- **Violation**: Helper methods returning widgets instead of private widget classes
- **Violation**: `print` usage possible (should use `dart:developer` `log`)
- **Violation**: No doc comments on many public APIs
- **Violation**: No `ThemeExtension` usage for custom design tokens (partially done with `EditorialTheme`)
- **Violation**: Dark theme is barebones compared to light theme

---

## Proposed Changes

### Phase 1 — Architecture Refactor

Reorganize into clean feature-based architecture:

```
lib/
├── main.dart
├── firebase_options.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── errors/
│   │   └── app_exceptions.dart
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── budget_service.dart
│   │   └── transaction_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── date_formatter.dart
│   │   └── icon_mapper.dart
│   └── widgets/
│       ├── app_bar.dart
│       ├── bottom_nav_bar.dart
│       └── cards.dart
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       └── authentication_screen.dart
│   ├── onboarding/
│   │   └── presentation/
│   │       └── onboarding_screen.dart
│   ├── home/
│   │   ├── data/
│   │   │   └── home_repository.dart
│   │   └── presentation/
│   │       ├── home_dashboard.dart
│   │       └── home_screen.dart
│   ├── transactions/
│   │   └── presentation/
│   │       ├── add_transaction_screen.dart
│   │       └── transactions_list_screen.dart
│   ├── analytics/
│   │   └── presentation/
│   │       └── analytics_insights_screen.dart
│   ├── budgets/
│   │   └── presentation/
│   │       └── budget_management_screen.dart
│   └── profile/
│       └── presentation/
│           └── profile_settings_screen.dart
└── models/  (shared across features)
    ├── budget_model.dart
    ├── transaction_model.dart
    └── user_model.dart
```

---

### Phase 2 — UI Fixes (Design Asset Alignment)

#### [MODIFY] Home Screen — Major Re-work
- Add greeting header ("Good Morning" + user name + profile avatar)
- Add Monthly Summary card (Income + Expenses breakdown)
- Add Weekly Spending bar chart
- Add "Add Expense" quick action alongside "Add Income"
- Add "+12.5% Since last month" trend badge to balance card
- Add background blob decorative element to balance card
- Add "View All" button to Recent Activity section header
- Compute balance dynamically from transaction stream

#### [MODIFY] Transactions List Screen — Significant changes
- Add branded top bar with profile avatar + "The Financial Atelier"
- Add "LEDGER" overline + large "Transactions" headline
- Group transactions by date with section headers
- Update search hint to "Search merchant or category..."
- Style "All" filter chip with primary color when selected

#### [MODIFY] Onboarding Screen — Visual enrichment
- Replace plain icon containers with richer card-based illustrations matching the design (overlaid spending/income mini-cards on top of illustration containers)

#### [MODIFY] Analytics Screen
- Add "TOTAL SPENT $X" center text in pie chart donut
- Fix hardcoded insight cards to use data from stream if available

#### [MODIFY] Authentication Screen
- Remove "Back to onboarding" button (not in design)
- Fix `FirebaseAuthException` catch to correct class

#### [MODIFY] Add Transaction Screen
- Remove duplicate bottom nav bar (shell route already provides it)

---

### Phase 3 — Bug Fixes & Code Quality

- Fix `FirebaseAuthException` → `FirebaseAuthException` (correct class name verification)
- Remove duplicate bottom nav bars from screens inside shell routes
- Replace helper methods with private widget classes (rules.md compliance)
- Use `DateFormatter` utility consistently instead of inline formatting
- Remove unused `UserModel` or wire it up
- Remove unused `BudgetCategoryCard` or wire it up
- Add proper error handling for Firebase calls
- Add loading/error/empty states consistently
- Fix dark theme to be complete (matching light theme component customization)

---

### Phase 4 — Firebase Verification

- Verify `google-services.json` exists in `android/app/`
- Verify iOS configuration files
- Add error handling utilities for Firebase exceptions
- Ensure auth state properly drives navigation

---

## User Review Required

> [!IMPORTANT]
> **Design Asset Discrepancy — Onboarding**: The design shows rich photo-based illustrations with overlaid data cards. Since actual photos cannot be bundled, I'll create visually rich containers with gradient backgrounds and overlaid data preview cards to approximate the design. Is this acceptable?

> [!IMPORTANT]
> **Home Balance Calculation**: Currently hardcoded to `$42,850.40`. The design also shows this value. Should I keep it hardcoded (matches design) or compute dynamically from Firestore transactions? I recommend keeping it as a visual match to the design but making it stream-powered.

> [!IMPORTANT]
> **Profile Screen Duplicate Bottom Nav**: The Profile screen has its own manual bottom nav but is NOT inside the shell route. Should I:
> - A) Move it inside the shell route (adds a 6th tab, which seems wrong), or
> - B) Keep it as a separate page with manual nav (current approach, acceptable)

## Verification Plan

### Automated Tests
- Run `flutter analyze` to verify no analyzer issues
- Run `flutter build apk --debug` to verify clean build

### Manual Verification
- Visual comparison of each screen against design screenshots
- Navigation flow verification: onboarding → auth → home → all tabs → profile
- Firebase auth flow: sign up, sign in, sign out
- Transaction CRUD flow
- Theme toggle (dark mode)
