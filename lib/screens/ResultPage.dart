import 'package:flutter/material.dart';
import 'package:g12/screens/homepage.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  String personalityType = 'NOC'; //假設後端回傳一個人格類型字串

  @override
  Widget build(BuildContext context) {
    //根據回傳的人格類型選擇對應的角色和圖片
    String roleName;
    String imagePath;
    Widget imageWidget;

    if(personalityType == 'NOC') {
      roleName = 'NOC';
      //存在yaml.assets裡面
      imagePath = 'assets/images/personality_NOC.png';
      //從網路上抓圖
      imageWidget = Image.network(
        'https://cdn2.ettoday.net/images/1674/1674351.jpg',
      );
    } else if(personalityType == 'S₁OC') {
      roleName = 'S₁OC';
      imagePath = 'assets/images/personality_S₁OC.png';
      imageWidget = Image.network(
        'https://cdn2.ettoday.net/images/1690/1690152.jpg',
      );
    } else if(personalityType == 'NGC') {
      roleName = 'NGC';
      imagePath = 'assets/images/personality_NGC.png';
      imageWidget = Image.network(
        'https://pic.pimg.tw/puddingbeauty/1459745492-3032475299.png',
      );
    }else if(personalityType == 'S₁GC') {
      roleName = 'S₁GC';
      imagePath = 'assets/images/personality_S₁GC.png';
      imageWidget =Image.network(
        'https://language.chinadaily.com.cn/images/attachement/jpg/site1/20160307/00221910993f1847589a2e.jpg',
      );
    } else if(personalityType == 'NOS₂') {
      roleName = 'NOS₂';
      imagePath = 'assets/images/personality_NOS₂.png';
      imageWidget =Image.network(
        'https://pic.pimg.tw/efilmclub/1495207637-858932256_wn.jpg',
      );
    } else if(personalityType == 'S₁OS₂') {
      roleName = 'S₁OS₂';
      imagePath = 'assets/images/personality_S₁OS₂.png';
      imageWidget = Image.network(
        'https://lh3.googleusercontent.com/FW4EC0cNfAMDf0lkXS1KmYnX1UNWwZ-jzU9A-K1Go_wB72jOtJ8CN1xv2BYqBSx2LxjU81_hX_JnoOE9lcy1RkqMGbBNVaPrbAMmynXd-agojagx9nBTs5thDKofkDXO0wXKk86RzpNz5pt3-UXreic9jQ5PU85G1AAAmJttkoaDxPK-D_3bK_sMx9IX2LJiNC6P86kZez1ztWl2AjgxKdsfw2sm-YabV4K_noxaDw9NvAMDF_piMg_LA9-FdR2GVGWFJcqfHh613b2tbAmu8tT8qDzRWonILBWTE88PmYACqdA_oI5b7CsRXQfpDG-UpDA_tjXt_vsJQ4PiYdQIjT6kJNlbB-y9FiVF0bjAHKqK5HZtNtQrWon2xR-IDEqWgoOdzpkEzwZx5iD1iaIBkkjGFAjvqd9UHsDOegahCPI5hH3m8DsG4inu-M3ldt4ei2nKX5w7AH1F5bWgeR0l0wNba6S5UTNiVQLSqo9UMkg6Z8suibXSUdS80xf9xH7G6LkIGO7kVSzhIagUfSvm5BzK7huKi5y3F7YRz7Oyk-luBDhPiIyrVboYKgvnGPKLx18O3Q=w1080-h662-no',
      );
    } else if(personalityType == 'NGS₂') {
      roleName = 'NGS₂';
      imagePath = 'assets/images/personality_NGS₂.png';
      imageWidget = Image.network(
        'https://pic.pimg.tw/efilmclub/1495207649-3772662795_n.jpg',
      );
    } else if(personalityType == 'S₁GS₂') {
      roleName = 'S₁GS₂';
      imagePath = 'assets/images/personality_S₁GS₂.png';
      imageWidget = Image.network(
        'https://cdn2.ettoday.net/images/2259/d2259465.jpg',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('測驗結果',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFAF0CA),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text('以下為您所對應的人格角色：\n',
                style: TextStyle(
                  color: Color(0xFF0D3B66),
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text("確認",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                    )
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFA493),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage(title: "Homepage")),
                    ModalRoute.withName('/'),
                  );
                },
              ),
              SizedBox(height: 20),
              Image.network(
                'https://cdn2.ettoday.net/images/1674/1674351.jpg',
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

