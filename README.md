### Version Control

+ `git pull` → `git commit` → `git push`

+ [Feature flags](https://discuss.kotlinlang.org/t/any-plans-for-having-conditional-compiling/1041) (format: id_date_description)
  
  + Unfinished feature: id = dai \ ling \ xi \ jia \ zhen
  
  + Merge branch: id = frontEnd \ backEnd
  
  + Testing: id = G12
  
  + Complete: remove flag

### Algorithm Design Logic

`[User: frequency , timespan , personalilty*3 , ability*3 , preference*3 , score*3]`
`[Workout: type , difficulty]`

```java
Main()  
{  
    user_score_array = SQL("SELECT scoreA, scoreB, scoreC FROM User")  
    chosen_type = Max(user_score_array)  
    user_aility = SQL("SELECT chosen_type_ability FROM User")

    candidate_list = SQL("SELECT workout FROM Workout WHERE difficulty < user_ability")

    result = Plan(candidate_list)  
}

Plan(candidate_list, user_score)  
{  
    do {  
        plan = Generate(candidate_list)  
    } while (CalcScore(plan) < user_score)  
    return plan  
}

CalcScore(plan)  
{  
    for each workout in plan  
        score += workout_difficulty * time  
    return score  
}

Generate(candidate_list)  
{  
    do {  
        workout = Randomize(candidate_list)  
        temp_plan.add(workout)  
        total_time += workout_time  
    } while (total_time < user_preset_time)  
    return temp_plan  
}
```
















































