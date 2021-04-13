import 'package:club_management/screens/member_detail.dart';
import 'package:club_management/utility/constants.dart';
import 'package:club_management/utility/member.dart';
import 'package:club_management/utility/session.dart';
import 'package:flutter/material.dart';

class MembersTab extends StatelessWidget {
  final List<Member> members;
  final List<Session> sessions;

  MembersTab({@required this.members, @required this.sessions});

  List<Widget> createMembers(context) {
    List<Widget> participantsWidgets = [];

    for (Member member in members) {
      participantsWidgets.add(
        Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemberDetail(
                      sessions: sessions,
                      member: member,
                      members: members,
                    ),
                  ));
            },
            title: Text('${member.firstName} ${member.lastName}'),
            subtitle: Text(EnglishRanks[member.rank]),
          ),
        ),
      );
    }
    return participantsWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: createMembers(context),
    );
  }
}
