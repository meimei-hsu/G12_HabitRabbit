import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  final Map arguments;

  const VideoPage({super.key, required this.arguments});

  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfdf5),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                //TODO: Change to video name
                Image.asset(
                  "assets/images/testPic.gif",
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop())),
              ],
            ),
            // TODO: Get description of item
            Column(
              children: [
                const SizedBox(height: 10),
                ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 0.0),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        widget.arguments['item'],
                        style: const TextStyle(
                            color: Color(0xff4b4370),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 10),
                      )
                    ),
                    subtitle: const Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              " \u2022  轉轉肩膀",
                              style: TextStyle(
                                  color: Color(0xff4b4370), fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              " \u2022  扭扭脖子",
                              style: TextStyle(
                                  color: Color(0xff4b4370), fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              " \u2022  動動嘴巴",
                              style: TextStyle(
                                  color: Color(0xff4b4370), fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
