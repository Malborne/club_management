import 'package:club_management/screens/session_detail.dart';
import 'package:flutter/material.dart';
import 'package:club_management/components/beautiful_card.dart';
import 'package:club_management/utility/constants.dart';
import 'package:club_management/utility/session.dart';

class SessionsTab extends StatelessWidget {
//  final List<Widget> sessionsWidgets = [];
  final List<Session> sessions;
  final members;

  SessionsTab({@required this.sessions, @required this.members});

  List<Widget> createSessions(context) {
    var i = 0;
    List<Widget> sessionsWidgets = [];
//    setState(() {
    for (Session session in sessions) {
      var sessionColor = Theme.of(context).brightness == Brightness.light
          ? kColors[i % kColors.length]
          : kDarkColors[i % kDarkColors.length];
      sessionsWidgets.add(BeautifulCard(
        text: session.title,
        color: sessionColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SessionDetail(
                  session: session,
                  sessionColor: Color(sessionColor),
                  members: members,
                  sessions: sessions,
                ),
              ));
        },
      ));

      i++;
    }
//    });
//    print('Session Widgets: ${sessionsWidgets.length}');

    return sessionsWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: createSessions(context),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
