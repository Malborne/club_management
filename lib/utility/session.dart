import 'package:club_management/utility/networking.dart';
import 'package:flutter/material.dart';
import 'package:club_management/components/text_bubble.dart';
import 'member.dart';

class Session {
  List<dynamic> attendees = [];
  DateTime date;
  TimeOfDay beginTime;
  TimeOfDay endTime;
  String location;
  String title;
  String room;
  String code;

  Session(
      {this.title,
      this.date,
      this.attendees,
      this.code,
      this.beginTime,
      this.endTime,
      this.location,
      this.room});

  Duration getDuration() => Duration(
      minutes: (60 * endTime.hour + endTime.minute) -
          (60 * beginTime.hour + beginTime.minute));

  List<Widget> getMembers({@required members}) {
    if (this.attendees.length == 0) {
      return [
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[],
        )
      ];
    } else {
      List<Widget> participantWidgets = [];
      var attendees = getAttendees(this.attendees, members);
      for (Member Part in attendees) {
        participantWidgets.add(Flex(
          direction: Axis.vertical,
          children: <Widget>[
            TextBubble(
              text: '${Part.firstName} ${Part.lastName}',
            ),
          ],
        ));
      }

      return participantWidgets;
    }
  }
}
