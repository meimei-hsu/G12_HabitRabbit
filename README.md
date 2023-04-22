# G12

A fitness habit APP.

## Class Diagram

```
---CRUD.dart 
    |---DB        (general database operations: create, read, update, delete)
---Database.dart
    |---Calendar  (get the days of the current and following weeks)
    |---PlanDB    (database operations for the plan children of the schedule table)
    |---UserDB    (database operations for the user table)    
---PlanAlgo.dart
    |---Algorithm (generate plan from the planning algorithm)    
    |---Data      (process the data in advance of running the algorithm)
```

## Version Control

- `git pull` → (conflict) → `git stash` → `git pull` → `git stash pop`

- `git pull` → (no conflict) → `git commit` → `git push`