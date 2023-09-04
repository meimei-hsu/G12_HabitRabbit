import 'package:flutter/material.dart';
import 'package:g12/screens/FriendStatusPage.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key, required arguments});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
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
        backgroundColor: const Color(0xfffdfdf5),
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Mary 的朋友圈',
            style: TextStyle(
                color: Color(0xff4b3d70),
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          backgroundColor: const Color(0xfffdfdf5),
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
                      //width: MediaQuery.of(context).size.width / 2,
                      child: TabBar(
                        controller: _controller,
                        tabs: const [
                          Tab(
                            icon: Tooltip(
                              message: '朋友列表',
                              child: Icon(Icons.person),
                            ),
                          ),
                          Tab(
                            icon: Tooltip(
                              message: '排行榜',
                              child: Icon(Icons.leaderboard),
                            ),
                          ),
                          Tab(
                            icon: Tooltip(
                              message: '團隊挑戰賽',
                              child: Icon(Icons.groups),
                            ),
                          ),
                        ],
                        unselectedLabelColor: const Color(0xff4b3d70),
                        /*indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          //color: const Color(0xffffffff).withOpacity(0.2),
                        ),*/
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
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
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
    //final List<int> colorCodes = <int>[600, 500, 100];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 16.0),
          child: Row(children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset('assets/images/image.png'),
            ),
            const SizedBox(width: 15),
            const Text(
              '社交碼：UGO317RQDS'
              '\n等級：12',
              // TODO:讀取使用者的真實情況
              style: TextStyle(
                color: Color(0xff4b3d70),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 15.0),
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
                    color: Color(0xff4b3d70),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                  onChanged: (value) {
                    setState(() {
                      isTextFieldEmpty = value.isEmpty;
                      searchText = value;
                      //print(searchText);
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
              color: Color(0xff4b3d70),
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
                    color: Color(0xff4b3d70),
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
                        //color: Colors.amber[colorCodes[index]],
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: CircleAvatar(
                              radius: 25,
                              //backgroundColor: Color(0xfffdfdf5),
                              backgroundImage:
                                  AssetImage('assets/images/Friend_B.png'),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            entries[index],
                            style: const TextStyle(
                              color: Color(0xff4b3d70),
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
                                color: Color(0xff4b3d70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 12,
                    );
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
              color: const Color(0xFFFDFDF5),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/Friend_A.png'),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Frank",
                  style: TextStyle(
                    color: Color(0xff4b3d70),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 60,
                  width: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10),
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
                            color: Color(0xff4b3d70),
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
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.leaderboard),
                      ),
                      Expanded(
                        child: Text(
                          "等級 \n10",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xff4b3d70),
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
                    backgroundColor: const Color(0xFFFFFFFF),
                  ),
                  child: const Text(
                    '加朋友',
                    style: TextStyle(
                      color: Color(0xff4b3d70),
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
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int type = 0;
  int personalRank = 0;
  int roleRank = 0;
  int exerciseRank = 0;
  int meditationRank = 0;

  //TODO: 抓前十名的資料
  final List<String> FriendPersonalRank = <String>[
    'Andy',
    'Bethany',
    'Daniel',
    'Chloe',
    'Mary'
  ];
  final List<String> WholePersonalRank = <String>[
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
  final List<String> FriendRoleRank = <String>[
    'Chloe',
    'Andy',
    'Mary',
    'Daniel',
    'Bethany'
  ];
  final List<String> WholeRoleRank = <String>[
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
  final List<String> FriendExerciseRank = <String>['Mary'];
  final List<String> WholeExerciseRank = <String>['Mary'];
  final List<String> FriendMeditationRank = <String>['Mary'];
  final List<String> WholeMeditationRank = <String>['Mary'];

  //個人排名
  List<String> getPersonalRankList() {
    if (type == 0) {
      return FriendPersonalRank;
    } else {
      return WholePersonalRank;
    }
  }

  //角色排名
  List<String> getRoleRankList() {
    if (type == 0) {
      return FriendRoleRank;
    } else {
      return WholeRoleRank;
    }
  }

  //運動寶物數量排名
  List<String> getExerciseRankList() {
    if (type == 0) {
      return FriendExerciseRank;
    } else {
      return WholeExerciseRank;
    }
  }

  //冥想寶物數量排名
  List<String> getMeditationRankList() {
    if (type == 0) {
      return FriendMeditationRank;
    } else {
      return WholeMeditationRank;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Padding(
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
                        color: const Color(0xfffdeed9),
                        border: Border.all(color: const Color(0xffffeed9)),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "個人等級排行榜",
                              style: TextStyle(
                                color: Color(0xff4b4370),
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            trailing: ToggleSwitch(
                              minHeight: 35,
                              initialLabelIndex: type,
                              cornerRadius: 10.0,
                              radiusStyle: true,
                              labels: const ['好友', '全用戶'],
                              activeBgColors: const [
                                [Color(0xfff6cdb7)],
                                [Color(0xffd4d6fc)],
                              ],
                              activeFgColor: const Color(0xff4b4370),
                              inactiveBgColor: const Color(0xfffdfdf5),
                              inactiveFgColor: const Color(0xff4b4370),
                              totalSwitches: 2,
                              onToggle: (index) {
                                type = index!;
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
                                      color: const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                'assets/images/Friend_B.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getPersonalRankList()[index],
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  return Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          getPersonalRankList()[index],
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                'assets/images/Friend_B.png'),
                                          ),
                                        ),
                                      ],
                                    ),
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
                          //若使用者的排名不在前十才須被列出
                          /*SizedBox(height: 20),
                      Container(
                        height: 30,
                        width: 285,
                        decoration: const BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Text('' // TODO: 使用者的真實排名
                                ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundImage:
                                    AssetImage('assets/images/image.png'),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                        ],
                      )),
                  const SizedBox(height: 15),
                  Container(
                      padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xfffdeed9),
                        border: Border.all(color: const Color(0xffffeed9)),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "角色等級排行榜",
                              style: TextStyle(
                                color: Color(0xff4b4370),
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            trailing: ToggleSwitch(
                              minHeight: 35,
                              cornerRadius: 10.0,
                              radiusStyle: true,
                              labels: const ['好友', '全用戶'],
                              activeBgColors: const [
                                [Color(0xfff6cdb7)],
                                [Color(0xffd4d6fc)],
                              ],
                              activeFgColor: const Color(0xff4b4370),
                              inactiveBgColor: const Color(0xfffdfdf5),
                              inactiveFgColor: const Color(0xff4b4370),
                              totalSwitches: 2,
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
                                      color: const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                'assets/images/Friend_B.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getRoleRankList()[index],
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                'assets/images/Friend_B.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getRoleRankList()[index],
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
                        color: const Color(0xfffdeed9),
                        border: Border.all(color: const Color(0xffffeed9)),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "運動寶物排行榜",
                              style: TextStyle(
                                color: Color(0xff4b4370),
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            trailing: ToggleSwitch(
                              minHeight: 35,
                              cornerRadius: 10.0,
                              radiusStyle: true,
                              labels: const ['好友', '全用戶'],
                              activeBgColors: const [
                                [Color(0xfff6cdb7)],
                                [Color(0xffd4d6fc)],
                              ],
                              activeFgColor: const Color(0xff4b4370),
                              inactiveBgColor: const Color(0xfffdfdf5),
                              inactiveFgColor: const Color(0xff4b4370),
                              totalSwitches: 2,
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
                                      color: const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                'assets/images/Friend_B.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getExerciseRankList()[index],
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                itemCount: getExerciseRankList().length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          getExerciseRankList()[index],
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                'assets/images/Friend_B.png'),
                                          ),
                                        ),
                                      ],
                                    ),
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
                        color: const Color(0xfffdeed9),
                        border: Border.all(color: const Color(0xffffeed9)),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              "冥想寶物排行榜",
                              style: TextStyle(
                                color: Color(0xff4b4370),
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            trailing: ToggleSwitch(
                              minHeight: 35,
                              cornerRadius: 10.0,
                              radiusStyle: true,
                              labels: const ['好友', '全用戶'],
                              activeBgColors: const [
                                [Color(0xfff6cdb7)],
                                [Color(0xffd4d6fc)],
                              ],
                              activeFgColor: const Color(0xff4b4370),
                              inactiveBgColor: const Color(0xfffdfdf5),
                              inactiveFgColor: const Color(0xff4b4370),
                              totalSwitches: 2,
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
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  final int rank = index + 1;

                                  return Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          '$rank',
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                'assets/images/Friend_B.png'),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          getMeditationRankList()[index],
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          getMeditationRankList()[index],
                                          style: const TextStyle(
                                            color: Color(0xff4b3d70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                          EdgeInsets.only(left: 16.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(
                                                'assets/images/Friend_B.png'),
                                          ),
                                        ),
                                      ],
                                    ),
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
                ]),
              ]),
    ));
  }
}

//團隊挑戰賽
class TeamChallengePage extends StatelessWidget {
  const TeamChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(left: 125.0, top: 25.0),
        child: Text(
          '團隊挑戰賽 Coming soon...',
          style: TextStyle(
            color: Color(0xff4b3d70),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
