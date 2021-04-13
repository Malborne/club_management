import 'package:club_management/utility/constants.dart';
import 'package:club_management/utility/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:club_management/utility/session.dart';
import 'package:club_management/components/text_bubble.dart';

class Member {
  String arabicFirst;
  String arabicLast;
  String code;
  String email;
  String firstName;
  String lastName;
  bool isCardPrinted;
  bool isCardReceived;
  List<dynamic> attendance = [];
  int rank;

  Member({
    this.arabicFirst,
    this.arabicLast,
    @required this.firstName,
    @required this.lastName,
    this.email = '',
    this.code,
    this.isCardPrinted = false,
    this.isCardReceived = false,
    this.rank = 0,
    this.attendance,
  });

  bool upgradeRank() {
    if (rank < EnglishRanks.length - 1) {
      rank++;
      return true;
    }
    return false;
  }

  List<Widget> getStars() {
    List<Widget> stars = [];

    for (var i = 0; i < rank + 1; i++) {
      stars.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Image(
            image: AssetImage('images/Star.png'),
            width: 25,
            height: 25,
            alignment: Alignment.topLeft,
          ),
        ),
      );
    }
    return stars;
  }

  List<Widget> getAttendedSessions({@required sessions}) {
    if (sessions == null || attendance == null || attendance.length == 0) {
      return [
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[],
        )
      ];
    } else {
      List<Widget> attendedSessions = [];
      for (Session session in getAttendance(this.attendance, sessions)) {
        attendedSessions.add(Flex(
          direction: Axis.vertical,
          children: <Widget>[
            TextBubble(
              text: '${session.title}',
            ),
          ],
        ));
      }

      return attendedSessions;
    }
  }
}
