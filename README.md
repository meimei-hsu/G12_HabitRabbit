# G12

A milestone habit App.

## Class Diagram

```
---CRUD.dart 
    |---DB                  (general database operations: create, read, update, delete)
    |---JournalDB           (database operations for JournalDB)
---Database.dart
    |---Calendar            (get the days of the current and following weeks)
    |---UserDB              (database operations for the users table)
    |---ContractDB          (database operations for the contract table)
    |---WorkoutDB           (database operations for the workouts table)
    |---MeditateDB          (database operations for the meditations table)
    |---PlanDB              (database operations for the workoutPlan children of the journal table)
    |---MeditationPlanDB    (database operations for the meditationPlan children of the journal table)
    |---Calculator          (statistic calculations for the DurationDB)
    |---DurationDB          (database operations for the workoutDuration children of the journal table)
    |---MeditationDurationDB(database operations for the meditationDuration children of the journal table)
    |---WeightDB            (database operations for the weight children of the journal table)
---PlanAlgo.dart
    |---PlanAlgo            (execute point of the workout planning algorithm)
    |---Algorithm           (generate plan from the workout planning algorithm)    
    |---PlanData            (process the workout data in advance of running the algorithm)
    |---MeditationPlanAlgo  (execute point of the meditaion planning algorithm)
    |---MeditationAlgorithm (generate plan from the meditaion planning algorithm)    
    |---MeditationPlanData  (process the meditaion data in advance of running the algorithm)
---Authentication.dart
    |---FireAuth            (user authentication by firebase)
    |---Validate            (check if the users' input are correct)
```

```
---RegisterPage.dart
    |---Login
    |---Signup
        |---QuestionnairePage.dart
---HomePage.dart
    |---HabitDetailPage.dart
        |---VideoPage.dart
        |---ExercisePage.dart
            |---CountdownPage.dart
    |---StatisticPage.dart
    |---MilestonePage.dart
        |---ContractPage.dart
            |---LinePayPage.dart
    |---CommunityPage.dart
        |---FriendStatusPage.dart
    |---SettingsPage.dart
---Routes.dart
---PageMaterial.dart
```

## Version Control

General situations:

- `git pull` → (conflict) → `git stash` → `git pull` → `git stash pop`

- `git pull` → (no conflict) → `git commit` → `git push`

If you forgot to pull before commit: 

- `git commit` → (conflict) → `git reset --soft HEAD~1` → `git stash` → `git pull` → `git stash pop`
