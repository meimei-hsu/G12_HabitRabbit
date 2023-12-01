# G12

A keystone habit App.

## Description
Habit Rabbit 基於人格分析理論規劃專屬你的習慣養成方案，給予有針對性的智慧建議，協助你有效達成目標。
瑣事交給我們，習慣養成交給你，一起收獲規律運動與冥想的好處！

Habit Rabbit 的四大功能：
📌 演算法客製計畫
📌 八大人格性格分類
📌 遊戲化習慣養成
📌 承諾合約自我約束

## Class Diagram

```
---crud.dart 
    |---DB                  (general database operations: create, read, update, delete)
    |---JournalDB           (database operations for JournalDB)
---database.dart
    |---Calendar            (get the days of the current and following weeks)
    |---UserDB              (operations for the users table)
    |---ContractDB          (operations for the contract table)
    |---GamificationDB      (operations for the gamification table)
    |---PokeDB              (operations for the poke notification table)
    |---HabitDB             (operations for the workouts and meditations table)
    |---PlanDB              (operations for the plan children of the journal table)
    |---Calculator          (statistic calculations for the DurationDB)
    |---DurationDB          (operations for the duration children of the journal table)
    |---WeightDB            (operations for the weight children of the journal table)
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
