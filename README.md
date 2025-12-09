# EzyAgric Farm Manager - Flutter Mobile App

A mobile application for field officers to manage farmers, farms, seasonal crop planning, and activity tracking with plan vs actual analysis.

## 📱 Features

- **Farmer & Farm Management**: Register farmers and their farms with detailed profiles
- **Season Planning**: Create crop season plans with planned activities and cost estimates
- **Activity Tracking**: Log actual field activities with dates, costs, and notes
- **Plan vs Actual Analysis**:
  - Compare planned vs actual costs
  - Track activity status (Completed, Upcoming, Overdue)
  - Identify overdue activities for timely intervention
- **Offline-First**: All data stored locally using `shared_preferences`

## 🏗️ Architecture & Design

### Clean Architecture

The app follows a clean, layered architecture:

```
lib/
├── models/          # Domain models (Farmer, Farm, SeasonPlan, Activities)
├── services/        # Business logic and data persistence
├── screens/         # UI screens
├── widgets/         # Reusable UI components
└── utils/          # Helper functions and constants
```

### Key Design Decisions

1. **Separation of Concerns**: Models are separate from business logic (services), which are separate from UI (screens/widgets)

2. **Service Layer**: All business logic is centralized in service classes:

   - `FarmerService`: Manages farmer CRUD operations
   - `FarmService`: Manages farm operations
   - `SeasonService`: Handles season plans, activities, and plan vs actual logic
   - `StorageService`: Handles data persistence

3. **Plan vs Actual Logic**: Implemented in `SeasonService.getSeasonSummary()`:

   - Compares each planned activity with actual activities by `activityType`
   - Determines status: COMPLETED, UPCOMING, or OVERDUE based on dates
   - Calculates cost variances and overdue counts

4. **Data Persistence**: Uses `shared_preferences` for offline storage with JSON serialization

5. **State Management**: Uses `setState` for simplicity (can be upgraded to Provider/Riverpod)

## 🚀 How to Run

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions
- An Android emulator or iOS simulator

### Steps

1. **Clone/Extract the project**

```bash
cd ezyagric_farm_manager
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

Or in VS Code/Android Studio:

- Press F5 or click the Run button
- Select your target device (emulator/physical device)

### Testing the App

1. **Add a Farmer**: Tap "View Farmers" → "+" button → Fill form
2. **Add a Farm**: Select farmer → "Add New Farm" → Enter details
3. **Create Season Plan**: Select farm → "Create Season Plan" → Enter crop and season name
4. **Add Planned Activities**:
   - In season detail, tap "Add Planned Activity"
   - Select activity type, set target date, enter estimated cost
5. **Log Actual Activities**:
   - Tap "Log Actual Activity"
   - Select activity type, actual date, cost, and notes
6. **View Summary**:
   - Tap "View Summary" to see plan vs actual comparison
   - Check activity statuses, cost analysis, and overdue count

## 📊 Plan vs Actual Logic Implementation

**Location**: `lib/services/season_service.dart` → `getSeasonSummary()` method

### How It Works:

1. **Activity Status Determination**:

```dart
- COMPLETED: Planned activity has matching actual activity (by activityType)
- UPCOMING: targetDate >= today AND no matching actual activity
- OVERDUE: targetDate < today AND no matching actual activity
```

2. **Cost Calculation**:

```dart
- Total Estimated Cost: Sum of all planned activities' estimatedCostUgx
- Total Actual Cost: Sum of all actual activities' actualCostUgx
- Cost Variance: actualCost - estimatedCost
```

3. **Overdue Tracking**:

```dart
- Count all planned activities where status == OVERDUE
- Display prominently in summary for field officer action
```

## 📱 Screenshots Flow

1. **Home Screen** → Lists all farmers
2. **Farmer Detail** → Shows farms for selected farmer
3. **Farm Detail** → Shows season plans for selected farm
4. **Season Summary** → Plan vs actual comparison with activity statuses
5. **Activity Logging** → Quick form to log field activities

## 🎨 UI/UX Considerations (Empathy)

- **Clear Visual Status**: Color-coded badges (green=completed, orange=upcoming, red=overdue)
- **Cost Visibility**: Large, clear cost displays with variance indicators
- **Simple Forms**: Minimal required fields, date pickers, dropdowns for easy data entry
- **Offline-First**: No internet required - perfect for field conditions
- **Quick Access**: Navigate farmers → farms → seasons → activities in logical flow

## 🔧 Technologies Used

- **Flutter**: 3.x
- **Dart**: 3.x
- **shared_preferences**: ^2.2.2 (local storage)
- **intl**: ^0.18.1 (date formatting)

## 🚀 Future Improvements

Given more time, I would implement:

1. **Backend Sync**:

   - Add REST API integration
   - Implement sync mechanism for offline-first + online backup
   - Handle conflict resolution

2. **Multi-Season Support**:

   - Season history and year-over-year comparisons
   - Season templates for common crops
   - Analytics dashboard

3. **Enhanced UX**:

   - Search and filter functionality
   - Bulk activity logging
   - Photo attachments for activities
   - Push notifications for overdue activities

4. **Advanced State Management**:

   - Migrate to Riverpod or Bloc for better scalability
   - Implement proper loading and error states

5. **Data Export**:

   - Export reports to PDF/Excel
   - Share season summaries via WhatsApp/email

6. **User Authentication**:

   - Field officer login
   - Role-based access control

7. **Localization**:
   - Multi-language support (English, Luganda, Swahili)

## 🏆 EzyAgric Values Demonstrated

- **Mastery**: Clean code structure, proper domain modeling, comprehensive business logic
- **Empathy**: User-friendly flows designed for field officers with limited connectivity
- **Agility**: Simple setup, modular design ready for feature extensions
- **Creative Thinking**: Smart plan vs actual comparison, status-based activity tracking
- **Passion**: Detailed documentation, thoughtful naming, production-ready code quality

## 👤 Author

Created for EzyAgric Software Engineer Technical Assignment

---

**Note**: This is a technical assignment submission demonstrating Flutter mobile development capabilities with focus on domain modeling, business logic implementation, and user-centric design.
