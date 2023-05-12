# G12

A fitness habit APP.

## Class Diagram

```
---CRUD.dart 
    |---DB        (general database operations: create, read, update, delete)
---Database.dart
    |---Calendar  (get the days of the current and following weeks)
    |---PlanDB    (database operations for the plan children of the journal table)
    |---DurationDB(database operations for the duration children of the journal table)
    |---UserDB    (database operations for the users table)
    |---WorkoutDB (database operations for the workouts table)
---PlanAlgo.dart
    |---PlanAlgo  (execute point of the planning algorithm)
    |---Algorithm (generate plan from the planning algorithm)    
    |---Data      (process the data in advance of running the algorithm)
---Authentication.dart
    |---FireAuth  (user authentication by firebase)
    |---Validate  (check if the users' input are correct)
```

```
---LoginPage.dart
    |---SignupPage.dart
---HomePage.dart
    |---ExercisePage.dart
        |---CountdownPage.dart
    |---StatisticPage.dart
    |---ContractPage.dart
```

## Version Control

- `git pull` → (conflict) → `git stash` → `git pull` → `git stash pop`

- `git pull` → (no conflict) → `git commit` → `git push`