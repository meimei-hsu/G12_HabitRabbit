# G12

A milestone habit App.

## Class Diagram

```
---crud.dart 
    |---DB                  (general database operations: create, read, update, delete)
    |---JournalDB           (database operations for JournalDB)
---database.dart
    |---Calendar            (get the days of the current and following weeks)
    |---UserDB              (database operations for the users table)
    |---ContractDB          (database operations for the contract table)
    |---GamificationDB      (database operations for the gamification table)
    |---PokeDB              (database operations for the poke notification table)
    |---HabitDB             (database operations for the workouts and meditations table)
    |---PlanDB              (database operations for the workoutPlan and meditationPlan children of the journal table)
    |---Calculator          (statistic calculations for the DurationDB)
    |---DurationDB          (database operations for the workoutDuration and meditationDuration children of the journal table)
    |---WeightDB            (database operations for the weight children of the journal table)
---plan_algo.dart
    |---PlanAlgo            (execute point of the planning algorithm)
    |---WorkoutAlgorithm    (generate plan from the workout planning algorithm)
    |---MeditationAlgorithm (generate plan from the meditaion planning algorithm)
---page_data.dart
    |---Data                (global variables and database records)
    |---PlanData            (local variables for PlanAlgo)
    |---HomeData            (local variables for HomePage)
    |---SettingsData        (local variables for SettingsPage)
    |---StatData            (local variables for StatisticPage)
    |---GameData            (local variables for GamificationPage)
    |---CommData            (local variables for CommunityPage)
    |---FriendData          (local variables for FriendStatusPage)
---authentication.dart
    |---FireAuth            (user authentication by firebase)
    |---Validate            (check if the users' input are correct)
---notification.dart        (notification service)
```

```
---register_page.dart
    |---LoginForm
    |---SignupForm
        |---survey_page.dart
---home_page.dart
    |---habit_detail_page.dart
        |---exercise_page.dart
            |---countdown_page.dart
    |---statistic_page.dart
    |---gamification_page.dart
        |---contract_page.dart
            |---line_pay_page.dart
    |---community_page.dart
        |---friend_status_page.dart
    |---settings_page.dart
---routes.dart
---page_material.dart
```

## Version Control

General situations:

- `git pull` → (conflict) → `git stash` → `git pull` → `git stash pop`

- `git pull` → (no conflict) → `git commit` → `git push`

If you forgot to pull before commit: 

- `git commit` → (conflict) → `git reset --soft HEAD~1` → `git stash` → `git pull` → `git stash pop`
