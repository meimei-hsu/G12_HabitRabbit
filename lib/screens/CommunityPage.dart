import 'package:flutter/material.dart';
import 'package:g12/screens/FriendStatusPage.dart';

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
                      print(searchText);
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
                                builder: (context) => const FriendStatusPage()));
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person),
                      ),
                      Expanded(
                        child: Text(
                          "社交碼 \nLSUG1T34SDT",
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
class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(left: 125.0, top: 25.0),
        child: Text(
          '排行榜 Coming soon...',
          style: TextStyle(
            color: Color(0xff4b3d70),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
