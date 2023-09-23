import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:g12/screens/friend_status_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:g12/screens/page_material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key, required arguments});

  @override
  CommunityPageState createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  User? user = FirebaseAuth.instance.currentUser;
  late TabController _controller;
  int _currentIndex = 0;

  final List<Widget> _tabViews = [
    const FriendListPage(),
    const LeaderboardPage(),
    const TeamChallengePage(),
  ];

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '${user?.displayName!} 的朋友圈',
            style: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          backgroundColor: ColorSet.backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      child: TabBar(
                        controller: _controller,
                        tabs: [
                          Tab(
                            icon: Column(
                              children: const [
                                Icon(
                                  Icons.group,
                                  color: ColorSet.iconColor,
                                ),
                                Text(
                                  '朋友列表',
                                  style: TextStyle(
                                    color: ColorSet.iconColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            icon: Column(
                              children: const [
                                Icon(
                                  Icons.emoji_events,
                                  color: ColorSet.iconColor, // 设置图标颜色
                                ),
                                Text(
                                  '排行榜',
                                  style: TextStyle(
                                    color: ColorSet.iconColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            icon: Column(
                              children: const [
                                Icon(
                                  Icons.sports_kabaddi,
                                  color: ColorSet.iconColor,
                                ),
                                Text(
                                  '團隊挑戰賽',
                                  style: TextStyle(
                                    color: ColorSet.iconColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        unselectedLabelColor: ColorSet.textColor,
                        onTap: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _tabViews,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//朋友列表
class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  FriendListPageState createState() => FriendListPageState();
}

class FriendListPageState extends State<FriendListPage> {
  String searchText = "";
  bool isTextFieldEmpty = true;

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>[
      //TODO: 從資料庫填資料
      'Andy',
      'Bethany',
      'Chloe',
      'Daniel',
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 16.0),
          child: Row(children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset('assets/images/Rabbit_2.png'),
            ),
            const SizedBox(width: 15),
            const Text(
              '\n社交碼：UGO317RQDS'
              '\n等級：12',
              // TODO:讀取使用者的真實情況
              style: TextStyle(
                color: ColorSet.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 10, right: 15.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '快輸社交碼 加入新朋友！',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  style: const TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isTextFieldEmpty = value.isEmpty;
                      searchText = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: isTextFieldEmpty
                    ? null
                    : () {
                        _showCustomDialog(context, "");
                        // TODO: 去後端找資訊出來
                      },
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20.0, right: 220.0),
          child: Text(
            '朋友列表',
            style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: entries.isEmpty
              ? const Text(
                  '\n您尚未加入任何好友，'
                  '\n趕快輸入朋友的社交碼開啟社交功能吧!',
                  style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.only(left: 40.0, top: 10.0, right: 40.0),
                  itemCount: entries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: ColorSet.backgroundColor,
                        border:
                            Border.all(color: ColorSet.borderColor, width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: ColorSet.backgroundColor,
                              backgroundImage:
                                  AssetImage('assets/images/Dog_1.png'),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            entries[index],
                            style: const TextStyle(
                              color: ColorSet.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FriendStatusPage()));
                              // TODO: 看到朋友的部分畫面
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: ColorSet.iconColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 12);
                  },
                ),
        ),
      ],
    );
  }

  void _showCustomDialog(BuildContext context, String receivedString) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: ColorSet.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: ColorSet.backgroundColor,
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/Fox_1.png'),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Frank",
                  style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 60,
                  width: 220,
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorSet.borderColor,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person),
                      ),
                      Expanded(
                        child: Text(
                          "社交碼 \n$searchText",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 60,
                  width: 220,
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorSet.borderColor,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.emoji_events),
                      ),
                      Expanded(
                        child: Text(
                          "等級 \n10",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    //TODO: 把朋友加進資料庫並顯示在 listView
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorSet.backgroundColor,
                  ),
                  child: const Text(
                    '加朋友',
                    style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//排行榜
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  LeaderboardPageState createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  int personalRank = 0;
  int roleRank = 0;
  int exerciseRank = 0;
  int meditationRank = 0;

  //TODO: 抓前十名的資料
  final List<String> friendPersonalRank = <String>[
    'Andy',
    'Bethany',
    'Daniel',
    'Chloe',
    'Mary'
  ];
  final List<String> wholePersonalRank = <String>[
    'Andy',
    'Frank',
    'Bethany',
    'John',
    'Daniel',
    'Kevin',
    'Angel',
    'Chloe',
    'Mary'
  ];
  final List<String> friendRoleRank = <String>[
    'Chloe',
    'Andy',
    'Mary',
    'Daniel',
    'Bethany'
  ];
  final List<String> wholeRoleRank = <String>[
    'Chloe',
    'Andy',
    'Frank',
    'Mary',
    'Daniel',
    'Kevin',
    'Angel',
    'Bethany',
    'John'
  ];
  final List<String> friendExerciseRank = <String>['Mary'];
  final List<String> wholeExerciseRank = <String>['Mary', 'Kevin', 'Angel'];
  final List<String> friendMeditationRank = <String>['Mary'];
  final List<String> wholeMeditationRank = <String>['Mary', 'Kevin', 'Angel'];

  //個人排名
  List<String> getPersonalRankList() {
    if (personalRank == 0) {
      return friendPersonalRank;
    } else {
      return wholePersonalRank;
    }
  }

  //角色排名
  List<String> getRoleRankList() {
    if (roleRank == 0) {
      return friendRoleRank;
    } else {
      return wholeRoleRank;
    }
  }

  //運動寶物數量排名
  List<String> getExerciseRankList() {
    if (exerciseRank == 0) {
      return friendExerciseRank;
    } else {
      return wholeExerciseRank;
    }
  }

  //冥想寶物數量排名
  List<String> getMeditationRankList() {
    if (meditationRank == 0) {
      return friendMeditationRank;
    } else {
      return wholeMeditationRank;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    border: Border.all(color: ColorSet.borderColor, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text(
                          "個人等級\n排行榜",
                          style: TextStyle(
                            color: ColorSet.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        trailing: ToggleSwitch(
                          minHeight: 35,
                          initialLabelIndex: personalRank,
                          cornerRadius: 10.0,
                          radiusStyle: true,
                          labels: const ['好友', '全用戶'],
                          activeBgColors: const [
                            [ColorSet.friendColor],
                            [ColorSet.usersColor]
                          ],
                          activeFgColor: ColorSet.textColor,
                          inactiveBgColor: ColorSet.bottomBarColor,
                          inactiveFgColor: ColorSet.textColor,
                          totalSwitches: 2,
                          onToggle: (index) {
                            personalRank = index!;
                            setState(() {});
                          },
                        ),
                      ),
                      Column(children: [
                        (personalRank == 0)
                            ? SizedBox(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 40.0, top: 10.0, right: 40.0),
                                  itemCount: getPersonalRankList().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int rank = index + 1;

                                    return Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: ColorSet.backgroundColor,
                                        border: Border.all(
                                            color: ColorSet.borderColor,
                                            width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Row(children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                ColorSet.backgroundColor,
                                            backgroundImage: AssetImage(
                                                'assets/images/Dog_1.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getPersonalRankList()[index],
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                ),
                              )
                            : SizedBox(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 40.0, top: 10.0, right: 40.0),
                                  itemCount: getPersonalRankList().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int rank = index + 1;

                                    return Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: ColorSet.backgroundColor,
                                        border: Border.all(
                                            color: ColorSet.borderColor,
                                            width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Row(children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                ColorSet.backgroundColor,
                                            backgroundImage: AssetImage(
                                                'assets/images/Dog_1.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getPersonalRankList()[index],
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                ),
                              )
                      ]),
                    ],
                  )),
              const SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    border: Border.all(color: ColorSet.borderColor, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text(
                          "角色等級\n排行榜",
                          style: TextStyle(
                            color: ColorSet.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        trailing: ToggleSwitch(
                          minHeight: 35,
                          initialLabelIndex: roleRank,
                          cornerRadius: 10.0,
                          radiusStyle: true,
                          labels: const ['好友', '全用戶'],
                          activeBgColors: const [
                            [ColorSet.friendColor],
                            [ColorSet.usersColor]
                          ],
                          activeFgColor: ColorSet.textColor,
                          inactiveBgColor: ColorSet.bottomBarColor,
                          inactiveFgColor: ColorSet.textColor,
                          totalSwitches: 2,
                          onToggle: (index) {
                            roleRank = index!;
                            setState(() {});
                          },
                        ),
                      ),
                      Column(children: [
                        (roleRank == 0)
                            ? SizedBox(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 40.0, top: 10.0, right: 40.0),
                                  itemCount: getRoleRankList().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int rank = index + 1;

                                    return Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: ColorSet.backgroundColor,
                                        border: Border.all(
                                            color: ColorSet.borderColor,
                                            width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Row(children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                ColorSet.backgroundColor,
                                            backgroundImage: AssetImage(
                                                'assets/images/Dog_1.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getRoleRankList()[index],
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                ),
                              )
                            : SizedBox(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 40.0, top: 10.0, right: 40.0),
                                  itemCount: getRoleRankList().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int rank = index + 1;

                                    return Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffffffff),
                                        border: Border.all(
                                            color: ColorSet.borderColor,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                ColorSet.backgroundColor,
                                            backgroundImage: AssetImage(
                                                'assets/images/Dog_1.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getRoleRankList()[index],
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                ),
                              )
                      ]),
                    ],
                  )),
              const SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    border: Border.all(color: ColorSet.borderColor, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text(
                          "運動寶物\n排行榜",
                          style: TextStyle(
                            color: ColorSet.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        trailing: ToggleSwitch(
                          minHeight: 35,
                          initialLabelIndex: exerciseRank,
                          cornerRadius: 10.0,
                          radiusStyle: true,
                          labels: const ['好友', '全用戶'],
                          activeBgColors: const [
                            [ColorSet.friendColor],
                            [ColorSet.usersColor]
                          ],
                          activeFgColor: ColorSet.textColor,
                          inactiveBgColor: ColorSet.bottomBarColor,
                          inactiveFgColor: ColorSet.textColor,
                          totalSwitches: 2,
                          onToggle: (index) {
                            exerciseRank = index!;
                            setState(() {});
                          },
                        ),
                      ),
                      Column(children: [
                        (exerciseRank == 0)
                            ? SizedBox(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 40.0, top: 10.0, right: 40.0),
                                  itemCount: getExerciseRankList().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int rank = index + 1;

                                    return Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: ColorSet.backgroundColor,
                                        border: Border.all(
                                            color: ColorSet.borderColor,
                                            width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Row(children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                ColorSet.backgroundColor,
                                            backgroundImage: AssetImage(
                                                'assets/images/Dog_1.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getExerciseRankList()[index],
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 5);
                                  },
                                ),
                              )
                            : SizedBox(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 40.0, top: 10.0, right: 40.0),
                                  itemCount: getExerciseRankList().length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int rank = index + 1;

                                    return Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffffffff),
                                        border: Border.all(
                                            color: ColorSet.borderColor,
                                            width: 2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                ColorSet.backgroundColor,
                                            backgroundImage: AssetImage(
                                                'assets/images/Dog_1.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getExerciseRankList()[index],
                                          style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                ),
                              )
                      ]),
                    ],
                  )),
              const SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    border: Border.all(color: ColorSet.borderColor, width: 4),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(children: [
                    ListTile(
                      title: const Text(
                        "冥想寶物\n排行榜",
                        style: TextStyle(
                          color: ColorSet.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      trailing: ToggleSwitch(
                        minHeight: 35,
                        initialLabelIndex: meditationRank,
                        cornerRadius: 10.0,
                        radiusStyle: true,
                        labels: const ['好友', '全用戶'],
                        activeBgColors: const [
                          [ColorSet.friendColor],
                          [ColorSet.usersColor]
                        ],
                        activeFgColor: ColorSet.textColor,
                        inactiveBgColor: ColorSet.bottomBarColor,
                        inactiveFgColor: ColorSet.textColor,
                        totalSwitches: 2,
                        onToggle: (index) {
                          meditationRank = index!;
                          setState(() {});
                        },
                      ),
                    ),
                    Column(children: [
                      (meditationRank == 0)
                          ? SizedBox(
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    left: 40.0, top: 10.0, right: 40.0),
                                itemCount: getMeditationRankList().length,
                                itemBuilder: (BuildContext context, int index) {
                                  final int rank = index + 1;

                                  return Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: ColorSet.backgroundColor,
                                      border: Border.all(
                                          color: ColorSet.borderColor,
                                          width: 2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: Row(children: [
                                      const SizedBox(width: 15),
                                      Text(
                                        '$rank',
                                        style: const TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor:
                                              ColorSet.backgroundColor,
                                          backgroundImage: AssetImage(
                                              'assets/images/Dog_1.png'),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        getMeditationRankList()[index],
                                        style: const TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 5,
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    left: 40.0, top: 10.0, right: 40.0),
                                itemCount: getMeditationRankList().length,
                                itemBuilder: (BuildContext context, int index) {
                                  final int rank = index + 1;

                                  return Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      border: Border.all(
                                          color: ColorSet.borderColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(children: [
                                      const SizedBox(width: 15),
                                      Text(
                                        '$rank',
                                        style: const TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor:
                                              ColorSet.backgroundColor,
                                          backgroundImage: AssetImage(
                                              'assets/images/Dog_1.png'),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        getMeditationRankList()[index],
                                        style: const TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 5,
                                  );
                                },
                              ),
                            )
                    ]),
                  ])),
            ]),
          ]),
    ));
  }
}

//團隊挑戰賽
final List<Widget> competitionList = [
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('初級(Lv1 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('七日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝利隊伍將獲得經驗值與等級的提升。',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('入門(Lv5 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('十四日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝利隊伍將獲得經驗值與等級的提升。',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('中級(Lv15 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('二十八日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝利隊伍將獲得經驗值與等級的提升。',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('進階(Lv20 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('三十二日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝利隊伍將獲得經驗值與等級的提升。',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('高級(Lv30 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('六十四日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝利隊伍將獲得經驗值與等級的提升。',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
];

final List<Widget> teamworkList = [
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('初級(Lv1 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('七日內所有成員進行運動或冥想習慣並達到完成度80%，隊伍獲得勝利並取得經驗值與等級提升的獎勵！',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('入門(Lv5 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('十四日內所有成員進行運動或冥想習慣並達到完成度80%，隊伍獲得勝利並取得經驗值與等級提升的獎勵！',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('中級(Lv15 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('十四日內所有成員進行運動或冥想習慣並達到完成度90%，隊伍獲得勝利並取得經驗值與等級提升的獎勵！',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('進階(Lv20 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('二十八日內所有成員進行運動或冥想習慣並達到完成度90%，隊伍獲得勝利並取得經驗值與等級提升的獎勵！',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
  Container(
    decoration: BoxDecoration(
      color: ColorSet.backgroundColor,
      border: Border.all(color: ColorSet.borderColor, width: 2),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('高級(Lv30 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('二十八日內所有成員進行運動或冥想習慣並達到完成度95%，隊伍獲得勝利並取得經驗值與等級提升的獎勵！',
              style: TextStyle(color: ColorSet.textColor, fontSize: 18.0)),
        ),
      ],
    ),
  ),
];

class TeamChallengePage extends StatefulWidget {
  const TeamChallengePage({super.key});

  @override
  TeamChallengePageState createState() => TeamChallengePageState();
}

class TeamChallengePageState extends State<TeamChallengePage> {
  final CarouselController _competitionController = CarouselController();
  final CarouselController _teamworkController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(height: 10),
        const Text('團隊競爭賽',
            style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 10),
        CarouselSlider(
          items: competitionList,
          carouselController: _competitionController,
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: ColorSet.backgroundColor,
                    title: const Text('團隊競爭賽',
                        style: TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        )),
                    content: const Text('PLEASE CHOOSE!',
                        style: TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                    actions: <Widget>[
                      Column(children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TeamCompetitionPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSet.backgroundColor,
                          ),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Team A',
                                  style: TextStyle(
                                    color: ColorSet.textColor,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '目前人數：',
                                  style: TextStyle(
                                    color: ColorSet.textColor,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TeamCompetitionPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSet.backgroundColor,
                          ),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Team B',
                                  style: TextStyle(
                                    color: ColorSet.textColor,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '目前人數：',
                                  style: TextStyle(
                                    color: ColorSet.textColor,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ])
                    ]);
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorSet.backgroundColor,
          ),
          child: const Text('確定加入',
              style: TextStyle(
                color: ColorSet.textColor,
                fontSize: 14.0,
              )),
        ),
        const SizedBox(height: 20),
        const Text('團隊合作賽',
            style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 10),
        CarouselSlider(
          items: teamworkList,
          carouselController: _teamworkController,
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            bool showTextField = false;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: ColorSet.backgroundColor,
                      title: const Text(
                        '團隊合作賽',
                        style: TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '選擇加入存在房間或建立新房間',
                            style: TextStyle(
                              color: ColorSet.textColor,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showTextField =
                                    !showTextField; // 點擊後切換TextField的顯示狀態
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorSet.backgroundColor,
                            ),
                            child: Text(
                              showTextField ? '輸入房間號' : '輸入房間號',
                              style: const TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          if (showTextField)
                            Row(
                              children: [
                                const Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    width: 150,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: '輸入房號！',
                                        contentPadding: EdgeInsets.all(5),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TeamWorkPage(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.check),
                                ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const TeamWorkPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorSet.backgroundColor,
                            ),
                            child: const Text(
                              '建立新房間',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          child: const Text(
            '確定加入',
            style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 14.0,
            ),
          ),
        ),
      ]),
    );
  }
}

//競爭賽樣貌
class TeamCompetitionPage extends StatefulWidget {
  const TeamCompetitionPage({super.key});

  @override
  TeamCompetitionPageState createState() => TeamCompetitionPageState();
}

class TeamCompetitionPageState extends State<TeamCompetitionPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfffdfdfd),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                child: Row(
                  children: const [
                    Text("團隊競爭賽",
                        style: TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 30.0,
                          letterSpacing: 1.0,
                        )),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                child: Text(
                    '七日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！'
                    '勝利隊伍將獲得經驗值與等級的提升。',
                    style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 22.0,
                    )),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                  child: Column(
                    children: [
                      ClipPath(
                        clipper: TeamAClipper(),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: ColorSet.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      ClipPath(
                        clipper: TeamBClipper(),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: ColorSet.backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamAClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();

    clippedPath.moveTo(0, 0); // 開始於左上角
    clippedPath.lineTo(size.width, 0); // 直線到右上角
    clippedPath.lineTo(size.width, size.height); // 直線到底部中心
    clippedPath.close(); // 連接左下角，完成三角形

    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class TeamBClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();

    clippedPath.moveTo(0, 0);
    clippedPath.lineTo(0, size.height);
    clippedPath.lineTo(size.width, size.height);
    clippedPath.close();

    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

//合作賽樣貌
class TeamWorkPage extends StatefulWidget {
  const TeamWorkPage({super.key});

  @override
  TeamWorkPageState createState() => TeamWorkPageState();
}

class TeamWorkPageState extends State<TeamWorkPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfffdfdfd),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                child: Row(
                  children: const [
                    Text("團隊合作賽",
                        style: TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 30.0,
                          letterSpacing: 1.0,
                        )),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                child: Text(
                    '7天內所有成員進行運動與冥想習慣並達到完成度80%，'
                    '隊伍獲得勝利並取得經驗值與等級提升的獎勵！',
                    style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 22.0,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 250.0, right: 30.0, top: 30.0),
                child: Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('房間號：'),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/images/Rabbit_2.png'),
                    ),
                    LinearPercentIndicator(
                      width: 250,
                      animation: true,
                      lineHeight: 20.0,
                      //TODO: 根據完成度改變 percent
                      percent: 0.7,
                      center: const Text(
                        "70%",
                        style: TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 10,
                        ),
                      ),
                      barRadius: const Radius.circular(16),
                      backgroundColor: Colors.black12,
                      progressColor: ColorSet.backgroundColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/images/Mouse_1.png'),
                    ),
                    LinearPercentIndicator(
                      width: 250,
                      animation: true,
                      lineHeight: 20.0,
                      //TODO: 根據完成度改變 percent
                      percent: 0.7,
                      center: const Text(
                        "70%",
                        style: TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 10,
                        ),
                      ),
                      barRadius: const Radius.circular(16),
                      backgroundColor: Colors.black12,
                      progressColor: ColorSet.backgroundColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
