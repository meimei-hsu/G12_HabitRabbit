import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:g12/screens/friend_status_page.dart';
import 'package:g12/screens/page_material.dart';
import 'package:g12/services/page_data.dart';

import '../services/database.dart';

final List<Widget> tabViews = [
  const FriendListPage(),
  const LeaderboardPage(),
  const TeamChallengePage(),
];

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  CommunityPageState createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  int _currentIndex = 0;

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

  void refresh() async {
    if (Data.updatingDB || Data.updatingUI[3]) await CommData.fetch();
    setState(() {
      tabViews[1] = const LeaderboardPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '${Data.profile?["userName"]} 的朋友圈',
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
                        indicatorColor: ColorSet.textColor,
                        indicatorWeight: 3,
                        indicator: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 3.0, color: ColorSet.borderColor),
                            ),
                            //borderRadius: BorderRadius.circular(10),
                            color: ColorSet.bottomBarColor),
                        tabs: const [
                          Tab(
                            icon: Column(
                              children: [
                                Icon(
                                  Icons.group,
                                  color: ColorSet.iconColor,
                                ),
                                Text(
                                  '朋友列表',
                                  style: TextStyle(
                                    color: ColorSet.textColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            icon: Column(
                              children: [
                                Icon(
                                  Icons.emoji_events,
                                  color: ColorSet.iconColor,
                                ),
                                Text(
                                  '排行榜',
                                  style: TextStyle(
                                    color: ColorSet.textColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            icon: Column(
                              children: [
                                Icon(
                                  Icons.sports_kabaddi,
                                  color: ColorSet.iconColor,
                                ),
                                Text(
                                  '團隊挑戰賽',
                                  style: TextStyle(
                                    color: ColorSet.textColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                  child: TabBarView(
                    controller: _controller,
                    children: tabViews,
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
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 16.0, right: 20.0),
            child: Row(children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(Data.characterImageURL),
              ),
              const SizedBox(width: 20),
              Text(
                '\n社交碼：${CommData.socialCode}'
                '\n等級：${CommData.level}',
                style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '快輸社交碼 加入新朋友！',
                      hintStyle: const TextStyle(color: ColorSet.hintColor),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: ColorSet.borderColor,
                          width: 3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: ColorSet.errorColor,
                          width: 3,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        color: ColorSet.iconColor,
                        iconSize: 20,
                        onPressed: () {
                          String searchText = _controller.text.trim();
                          String? fullID =
                              GamificationDB.convertSocialCode(searchText);
                          if (searchText.isEmpty) {
                            HintDialog()
                                .get(context, "提示",
                                    "社交碼清單：\n${Data.community?.keys.map((e) => e.substring(0, 7)).toList()}")
                                .show();
                          } else {
                            if (fullID == null) {
                              ErrorDialog()
                                  .get(context, "警告！", "找不到該名用戶T^T")
                                  .show();
                              _controller.clear();
                            } else if (searchText == CommData.socialCode) {
                              ErrorDialog()
                                  .get(context, "警告！", "不能新增自己為朋友喔T^T")
                                  .show();
                              _controller.clear();
                            } else if (CommData.friends.contains(fullID)) {
                              ErrorDialog()
                                  .get(context, "警告！", "朋友已在清單內:) \n 快去認識新朋友吧~")
                                  .show();
                              _controller.clear();
                            } else {
                              _showCustomDialog(context,
                                  userID: fullID, isFriend: false);
                              _controller.clear();
                            }
                          }
                          // Unfocus the keyboard
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    cursorColor: ColorSet.errorColor,
                    style: const TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 20.0, left: 25.0),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '朋友列表',
                    style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
          Expanded(
            child: CommData.friends.isEmpty
                ? const Text(
                    '\n尚未加入任何好友T^T'
                    '\n趕快輸入朋友的社交碼開啟社交功能吧！',
                    style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                        left: 25.0, top: 10.0, right: 25.0),
                    itemCount: CommData.friends.length,
                    itemBuilder: (BuildContext context, int index) {
                      String friendID = CommData.friends[index];
                      Map? info = Data.community?[friendID];
                      return (info == null)
                          ? Container()
                          : Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: ColorSet.backgroundColor,
                                border: Border.all(
                                    color: ColorSet.borderColor, width: 2),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  _showCustomDialog(context,
                                      userID: friendID, isFriend: true);
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            ColorSet.backgroundColor,
                                        backgroundImage: AssetImage(
                                            'assets/images/${info["character"]}_head.png'),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      info["userName"],
                                      style: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: ColorSet.iconColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 12);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showCustomDialog(BuildContext context,
      {required String userID, required bool isFriend}) {
    Map info = Data.community?[userID];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: ColorSet.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: ColorSet.backgroundColor,
                  radius: 45,
                  backgroundImage:
                      AssetImage('assets/images/${info["character"]}_head.png'),
                ),
                const SizedBox(height: 15),
                Text(
                  info["userName"],
                  style: const TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: ColorSet.borderColor,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person, color: ColorSet.iconColor),
                      ),
                      Expanded(
                        child: Text(
                          "社交碼 \n${userID.substring(0, 7)}",
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
                  width: 250,
                  decoration: BoxDecoration(
                    color: ColorSet.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: ColorSet.borderColor,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Icon(Icons.emoji_events, color: ColorSet.iconColor),
                      ),
                      Expanded(
                        child: Text(
                          "等級 \n${info["level"]}",
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
                const SizedBox(height: 20),
                (isFriend)
                    ? Container(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () {
                                PokeDB.update(userID);
                                InformDialog()
                                    .get(context, "戳到了:)",
                                        "謝謝你提醒${info['userName']}持續養成習慣，\n有你這個朋友真好!")
                                    .show();
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                backgroundColor: ColorSet.bottomBarColor,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                '戳戳他',
                                style: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () {
                                CommData.currentFriend = userID;
                                FriendData.fetch();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FriendStatusPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                backgroundColor: ColorSet.bottomBarColor,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                '看看他',
                                style: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                          ],
                        ))
                    : ElevatedButton(
                        onPressed: () async {
                          CommData.friends.insert(0, userID);
                          await GamificationDB.updateFriend(userID);
                          if (!mounted) return;
                          Navigator.of(context).pop();
                          setState(() {
                            tabViews[1] = const LeaderboardPage();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          backgroundColor: ColorSet.bottomBarColor,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
  List<int> toggles = [0, 0, 0, 0];

  Map getChart(int index) {
    if (toggles[index] == 0) index += 3;
    return Map.from(CommData.globalCharts[index]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (BuildContext context, int ordinalNum) {
            Map chart = getChart(ordinalNum);
            List titles = ["個人等級", "運動寶物", "冥想寶物"];
            return Container(
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
                    title: Text(
                      "${titles[ordinalNum]}\n排行榜",
                      style: const TextStyle(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    trailing: ToggleSwitch(
                      minHeight: 35,
                      initialLabelIndex: toggles[ordinalNum],
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
                        toggles[ordinalNum] = index!;
                        setState(() {});
                      },
                    ),
                  ),
                  (CommData.friends.isEmpty && toggles[ordinalNum] == 0)
                      ? const Text(
                          '\n尚未加入任何好友T^T',
                          style: TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Column(children: [
                          SizedBox(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 40.0, top: 10.0, right: 40.0),
                              itemCount: chart.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String uid = chart.keys.toList()[index];
                                final bool isCurrentUser = (chart[uid][2] ==
                                    Data.profile?["userName"]);
                                final Color containerColor = isCurrentUser
                                    ? (toggles[ordinalNum] == 0)
                                        ? ColorSet.friendColor
                                        : ColorSet.usersColor
                                    : ColorSet.backgroundColor;

                                return Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    border: Border.all(
                                        color: ColorSet.borderColor, width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                  child: Row(children: [
                                    const SizedBox(width: 15),
                                    Text(
                                      '${chart[uid][0]}'.padLeft(2, "  "),
                                      style: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            ColorSet.backgroundColor,
                                        backgroundImage: AssetImage(chart[uid]
                                                [1] ??
                                            'assets/images/Dog_1_head.png'),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      chart[uid][2],
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
                        ]),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 15);
          },
        ),
      ),
    );
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
    child: const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('初級(Lv1 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('七日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝隊將獲得經驗值與等級的提升。',
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
    child: const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('入門(Lv5 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('十四日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝隊將獲得經驗值與等級的提升。',
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
    child: const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('中級(Lv15 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('二十八日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝隊將獲得經驗值與等級的提升。',
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
    child: const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('進階(Lv20 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('三十二日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝隊將獲得經驗值與等級的提升。',
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
    child: const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('高級(Lv30 可選擇)',
              style: TextStyle(color: ColorSet.textColor, fontSize: 22.0)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text('六十四日內組內所有成員進行運動或冥想的習慣養成，兩隊中完成度較高者為勝！勝隊將獲得經驗值與等級的提升。',
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
    child: const Column(
      children: [
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
    child: const Column(
      children: [
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
    child: const Column(
      children: [
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
    child: const Column(
      children: [
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
    child: const Column(
      children: [
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
            height: MediaQuery.of(context).size.height * 0.27,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Container(
            padding: const EdgeInsets.only(left: 100.0, right: 100.0),
            child: ElevatedButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.noHeader,
                  autoHide: const Duration(seconds: 2),
                  body: SizedBox(
                    width: 400.0,
                    height: 100.0,
                    child: Image.asset("assets/images/coming_soon.png"),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  dialogBorderRadius:
                      const BorderRadius.all(Radius.circular(20)),
                ).show();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSet.bottomBarColor,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '確定加入',
                style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            )),
        /*ElevatedButton(
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Coming Soon"),
                                  content: const Text("此功能即將推出。敬請期待！"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("關閉"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSet.backgroundColor,
                          ),
                          child: const Row(
                            children: [
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Coming Soon"),
                                  content: const Text("此功能即將推出。敬請期待！"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("關閉"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSet.backgroundColor,
                          ),
                          child: const Row(
                            children: [
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
        ),*/
        const SizedBox(height: 5),
        const Divider(
          thickness: 1.5,
          color: ColorSet.bottomBarColor,
          indent: 10,
          endIndent: 10,
        ),
        const SizedBox(height: 5),
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
            height: MediaQuery.of(context).size.height * 0.27,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Container(
            padding: const EdgeInsets.only(left: 100.0, right: 100.0),
            child: ElevatedButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.noHeader,
                  autoHide: const Duration(seconds: 2),
                  body: SizedBox(
                    width: 400.0,
                    height: 100.0,
                    child: Image.asset("assets/images/coming_soon.png"),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  dialogBorderRadius:
                      const BorderRadius.all(Radius.circular(20)),
                ).show();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSet.bottomBarColor,
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '確定加入',
                style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            )),
        /*ElevatedButton(
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Coming Soon"),
                                          content: const Text("此功能即將推出。敬請期待！"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("關閉"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.check),
                                ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Coming Soon"),
                                    content: const Text("此功能即將推出。敬請期待！"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("關閉"),
                                      ),
                                    ],
                                  );
                                },
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
                          )
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
        ),*/
      ]),
    );
  }
}

//競爭賽樣貌
/*class TeamCompetitionPage extends StatefulWidget {
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
}*/

//合作賽樣貌
/*class TeamWorkPage extends StatefulWidget {
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
                      child: Image.asset(Data.characterImageURL),
                    ),
                    LinearPercentIndicator(
                      width: 250,
                      animation: true,
                      lineHeight: 20.0,
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
}*/
