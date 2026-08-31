# 🛺 Project 3 Wheel (Apple Liquid Glass Fleet & Financial Hub)

> A cross-platform **Flutter Mobile App & Web Dashboard** built with **Apple's Liquid Glass Design System** (iOS Frosted Dynamic System) for managing electric and traditional rickshaw fleets, real-time collections, expense tracking, automated Bengali SMS debt reminders, and 1-click financial audit reports.

---

## 🎨 Liquid Glass Design System Highlights
- **BackdropFilter & Dynamic Blur**: Multi-layer gaussian blur (`sigmaX: 16.0, sigmaY: 16.0` up to `24.0` for heavy modals and sidebars).
- **Translucency**: Frosted translucent layers (`Color(0x1AFFFFFF)` ~ 10% white, `Color(0x33000000)` ~ 20% dark).
- **Specular Reflection Borders**: 1px specular light gradient border (`LinearGradient` from 35% white to 5% white) for realistic glass refraction.
- **Fluid Gradients**: Smooth `BorderRadius.circular(24.0)`, drop shadows with low opacity blur, and vibrant pastel accents:
  - 🟢 **Emerald Green (`#10B981`)**: Income, Full Paid status, Online indicators.
  - 🔴 **Crimson Red (`#FF3B30`)**: Expenses, Defaulters, Overdue amounts.
  - 🟡 **Electric Amber (`#FF9500`)**: Partial Dues, Maintenance, Offline sync queue.
  - 🔵 **Liquid Blue (`#0A84FF`)**: Primary action buttons and fleet branding.

---

## 🏗️ Architecture & Tech Stack

```
project_3_wheel/
├── lib/
│   ├── core/                  # Design tokens, typography, connectivity monitor & formatters
│   ├── models/                # Clean data models (Users, Rickshaws, Drivers, Collections, Expenses, SMS Logs, Sync Records)
│   ├── services/              # Hive offline storage, SyncEngine, SMS Gateway, PDF/Excel report engines, Mock seeder
│   ├── repositories/          # Repositories with offline-first CRUD & sync dispatching
│   ├── providers/             # Riverpod state notifiers (Auth, Fleet, Collections, Expenses, Sync, Financial P&L)
│   ├── widgets/               # Liquid Glass UI components (Containers, Cards, Buttons, TextFields, Badges, Modals, Bars)
│   ├── screens/               # Auth, Web Owner Dashboard, Mobile Manager Home, QR Scanner, Ledgers, Reports, GPS Coming Soon
│   └── main.dart              # App bootstrap, Riverpod ProviderScope, and theme configuration
```

- **Framework**: Flutter (iOS, Android, Web Dashboard, macOS)
- **State Management**: `flutter_riverpod` (v2.5.1)
- **Cloud & Backend**: Firebase Firestore, Firebase Auth, Firebase Storage
- **Offline Storage & Sync**: `hive` + `hive_flutter` + `connectivity_plus`
- **Scanner**: `mobile_scanner` with custom liquid glass viewfinder overlay
- **Report Generation**: `pdf`, `printing`, `excel`
- **SMS Gateway**: REST client for Greenweb / BdSMS with localized Bengali template engine

---

## 🗄️ Database Schemas

1. **`users`**: `{ uid, name, role ['owner', 'manager'], phone }`
2. **`rickshaws`**: `{ rickshaw_id (e.g. 'R-01'), qr_code, status ['active', 'maintenance'], device_imei, daily_rent_rate, last_location: { lat, lng, speed, updated_at } }`
3. **`drivers`**: `{ driver_id, name, phone, nid, total_due, active_rickshaw_id, address, joined_date }`
4. **`daily_collections`**: `{ id, date, rickshaw_id, driver_id, driver_name, expected_amount, paid_amount, due_amount, payment_status ['paid', 'due', 'unpaid'], recorded_by, is_synced }`
5. **`expenses`**: `{ id, date, category ['mechanic', 'parts', 'rent', 'line_fee', 'other'], amount, receipt_image_url, note, recorded_by, is_synced }`
6. **`sms_logs`**: `{ log_id, driver_id, driver_name, driver_phone, message, timestamp, status, response_info }`

---

## 🚀 Key Feature Breakdown

### Phase 1: Offline-First Engine & QR Scanner
- **Hive Local Storage**: Caches collections, expenses, drivers, and pending sync records.
- **Auto-Sync Engine**: Watches connectivity transitions (`connectivity_plus`) and automatically flushes queued writes to Firebase Firestore when back online.
- **Liquid Glass QR Scanner**: Camera viewfinder with laser sweep animation, torch toggle, and instant glass modal bottom sheet displaying driver info, today's collection status, and cumulative dues.
- **Daily Collection & Expense Forms**: Auto-calculates remaining due in real-time based on standard rent rates.

### Phase 2: Dynamic Reporting & Automated SMS Gateway
- **Bengali SMS Gateway**: Integrated with BdSMS / Greenweb API to dispatch localized SMS debt reminders:
  > *"শ্রদ্ধেয় করিম ভাই, প্রজেক্ট ৩ হুইল গ্যারেজে আপনার বকেয়া পাওনা ৳৭০০ টাকা। অনুগ্রহ করে দ্রুত পরিশোধ করুন। ধন্যবাদ।"*
- **1-Click PDF Engine**: Generates vectorized, branded PDF reports for Daily Collection Summaries, Monthly Profit & Loss statements, and Defaulters Lists.
- **1-Click Excel Engine**: Exports formatted multi-sheet workbooks (.xlsx) with collections, expenses, and driver ledgers.

### Phase 3: Adaptive Responsive Layouts (Web & Mobile)
- **Web Dashboard (Fleet Owner View)**:
  - Translucent glass sidebar with active glowing indicator.
  - High-gloss P&L Metric Cards (Today's Revenue, Daily Expenses, Net Cash Flow, Total Dues).
  - Defaulters table with glass status pills and direct 1-tap SMS dispatching.
  - Owner-only administrative controls.
- **Mobile App (Garage Manager View)**:
  - Floating Glass Bottom Navigation Bar with quick action FAB.
  - Strict manager permissions (Read & Add entries only; No delete/override access).

### Phase 4: GPS Tracking Module (IoT Ready)
- Liquid Glass Placeholder Screen featuring an animated glowing 3D vector satellite orb, radar sweep, and status badges.
- Underlying data schema (`rickshaws.last_location`) fully intact for future telematics activation.

---

## 🛠️ Getting Started

### 1. Open the project in your IDE
Open `/Users/rmacstudio2/.gemini/antigravity/scratch/project_3_wheel` as your workspace.

### 2. Run the application
```bash
flutter pub get
flutter run -d chrome      # Web Dashboard (Owner View)
# OR
flutter run -d macos       # Desktop
# OR
flutter run -d ios/android # Mobile App (Manager View)
```

*(Note: If Firebase credentials are not yet configured in your local environment, the app automatically runs in local Hive / Offline simulation mode with pre-seeded Dhaka fleet data so everything is 100% interactive out of the box!)*
