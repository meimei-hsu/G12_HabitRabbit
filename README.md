# G12

A milestone habit App.

## Class Diagram

```
---CRUD.dart 
    |---DB        (general database operations: create, read, update, delete)
    |---JournalDB (database operations for JournalDB)
---Database.dart
    |---Calendar  (get the days of the current and following weeks)
    |---UserDB    (database operations for the users table)
    |---ContractDB(database operations for the contract table)
    |---WorkoutDB (database operations for the workouts table)
    |---PlanDB    (database operations for the plan children of the journal table)
    |---DurationDB(database operations for the duration children of the journal table)
    |---WeightDB  (database operations for the weight children of the journal table)
---PlanAlgo.dart
    |---PlanAlgo  (execute point of the planning algorithm)
    |---Algorithm (generate plan from the planning algorithm)    
    |---PlanData  (process the data in advance of running the algorithm)
---Authentication.dart
    |---FireAuth  (user authentication by firebase)
    |---Validate  (check if the users' input are correct)
```

```
---RegisterPage.dart
    |---Login
    |---Signup
        |---QuestionnairePage.dart
    |---ForgetPassword
---HomePage.dart
    |---ExercisePage.dart
        |---CountdownPage.dart
    |---StatisticPage.dart
    |---ContractPage.dart
        |---LinePayPage.dart
    |---SettingsPage.dart
---Routes.dart
```

## Version Control

General situations:

- `git pull` → (conflict) → `git stash` → `git pull` → `git stash pop`

- `git pull` → (no conflict) → `git commit` → `git push`

If you forgot to pull before commit: 

- `git commit` → (conflict) → `git reset --soft HEAD~1` → `git stash` → `git pull` → `git stash pop`
