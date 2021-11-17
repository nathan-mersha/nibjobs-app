import 'package:flutter/material.dart';
import 'package:nibjobs/api/config/global.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  static final welcomePage = [
    // First welcome page
    {
      "title": StringRsr.get(LanguageKey.TITLE_ONE, firstCap: true),
      "description": StringRsr.get(LanguageKey.TITLE_ONE_BODY, firstCap: true),
      "image": "assets/images/apply_for_job.png"
    },

    // Second welcome page
    {
      "title": StringRsr.get(LanguageKey.TITLE_TWO, firstCap: true),
      "description": StringRsr.get(LanguageKey.TITLE_TWO_BODY, firstCap: true),
      "image": "assets/images/create_job.png"
    },

    // Third welcome page
    {
      "title": StringRsr.get(LanguageKey.TITLE_THREE, firstCap: true),
      "description":
          StringRsr.get(LanguageKey.TITLE_THREE_BODY, firstCap: true),
      "image": "assets/images/make_money.png"
    },
  ];

  int currentPage = 0;
  PageController? controller;

  @override
  Widget build(BuildContext context) {
    controller = PageController(initialPage: 0);
    ApiGlobalConfig.get();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: controller,
              children: <Widget>[
                getWelcomeScreens(0),
                getWelcomeScreens(1),
                getWelcomeScreens(2),
              ],
              onPageChanged: (pageIndex) {
                setState(() {
                  currentPage = pageIndex;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: getPositionIndicators(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RouteTo.PROFILE_SIGN_IN);
                      },
                      child: Text(
                        StringRsr.get(LanguageKey.REGISTER, firstCap: true)!,
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RouteTo.PROFILE_SIGN_IN);
                      },
                      child: Text(
                        StringRsr.get(LanguageKey.SKIP, firstCap: true)!,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getPositionIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(
              minRadius: 3,
              maxRadius: 3,
              backgroundColor: currentPage == 0
                  ? Theme.of(context).primaryColor
                  : Colors.black54,
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(
              minRadius: 3,
              maxRadius: 3,
              backgroundColor: currentPage == 1
                  ? Theme.of(context).primaryColor
                  : Colors.black54,
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(
              minRadius: 3,
              maxRadius: 3,
              backgroundColor: currentPage == 2
                  ? Theme.of(context).primaryColor
                  : Colors.black54,
            )),
      ],
    );
  }

  Widget getWelcomeScreens(int index) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 12),
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
            Image.asset(
              welcomePage[index]["image"]!,
              height: 300,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                Text(
                  welcomePage[index]["title"]!,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 19),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 35, horizontal: 95),
                  child: Text(
                    welcomePage[index]["description"]!,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                )
              ],
            ),
          ])),
    );
  }
}
