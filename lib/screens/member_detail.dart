import 'package:club_management/screens/add_member.dart';
import 'package:club_management/screens/add_sessions_screen.dart';
import 'package:club_management/utility/networking.dart';
import 'package:club_management/utility/session.dart';
import 'package:flutter/material.dart';
import 'package:club_management/utility/member.dart';
import 'package:club_management/components/my_icon_button.dart';
import 'package:club_management/components/my_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:club_management/utility/constants.dart';

class MemberDetail extends StatefulWidget {
  final List<Session> sessions;
  final List<Member> members;
  final Member member;

  MemberDetail(
      {@required this.member, @required this.members, @required this.sessions});
  @override
  _MemberDetailState createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
  Member member;

  @override
  void initState() {
    member = widget.member;
    super.initState();
  }

  void editMember() async {
    var editedMember = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddMember(
            members: widget.members,
            currentMember: member,
            sessions: widget.sessions,
          ),
        ));
    if (editedMember != null) {
      setState(() {
        widget.members[widget.members.indexOf(member)] = editedMember;
        member = editedMember;
        print('Rank: ${member.rank}');
        print('updating member on firestore');
        //updating the data on firestore
        updateMemberFirestore(member.code, {
          'FirstName': member.firstName,
          'LastName': member.lastName,
          'ArabicFirst': member.arabicFirst,
          'ArabicLast': member.arabicLast,
          'Code': member.code,
          'email': member.email,
          'Rank': member.rank,
          'IsCardPrinted': member.isCardPrinted,
          'IsCardReceived': member.isCardReceived,
          'Attendance': member.attendance,
        });
      });
    }
  }

  Future<void> deleteMember() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Member'),
          content:
              Text('Are you sure you want to permenantly delete this member?.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                // implement delete session
                widget.members.remove(member);
                //deleting the session from firestore
                deleteMemberFirestore(member.code);

                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String membersNumberText() {
    if (member.attendance == null || member.attendance.length == 0)
      return 'Attended zero sessions';
    else if (member.attendance.length == 1)
      return 'Attended 1 session';
    else
      return 'Attended ${member.attendance.length} sessions';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Memeber Details'),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: editMember,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                onPressed: deleteMember,
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 5, top: 5),
                        leading: Text(
                          'Name: ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        title: Text(
                          '${member.firstName} ${member.lastName}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 5, top: 5),
                        leading: Text(
                          'Email: ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        title: Text(
                          '${member.email != null ? member.email : ''}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 5, top: 5),
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'Rank: ',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${EnglishRanks[member.rank]}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            FittedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: member.getStars(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 5, top: 5),
                        leading: Text(
                          'Code: ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        title: Text(
                          '${member.code != null ? member.code : ''}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    membersNumberText(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    direction: Axis.horizontal,
                    children:
                        member.getAttendedSessions(sessions: widget.sessions),
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Material(
                  elevation: 10,
                  child: Container(
                    color: Theme.of(context).bottomAppBarColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//        alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        MyIconButton(
                          icon: Icons.edit,
                          size: 40,
                          shape: CircleBorder(),
                          onPressed: editMember,
                          color: Colors.transparent,
                          iconColor: Theme.of(context).buttonColor,
                        ),
                        MyIconButton(
                          icon: MyIcons.upgradeRank,
                          size: 40,
                          shape: CircleBorder(),
                          onPressed: () {
                            setState(() {
                              if (member.upgradeRank())
                                updateMemberFirestore(member.code, {
                                  'Rank': member.rank,
                                });
                            });
                          },
                          color: Colors.transparent,
                          iconColor: Theme.of(context).buttonColor,
                        ),
                        MyIconButton(
                          icon: FontAwesomeIcons.plus,
                          size: 24,
                          buttonSize: 48,
                          shape: CircleBorder(),
                          onPressed: () async {
                            List<dynamic> selectedSessions =
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddSessionsScreen(
                                              sessions: widget.sessions,
                                              previouslySelected: getAttendance(
                                                  member.attendance,
                                                  widget.sessions),
                                            )));
                            if (selectedSessions != null) {
                              member.attendance = selectedSessions
                                  .map((session) => session.code)
                                  .toList();

                              //updating the data on firestore
                              updateMemberFirestore(member.code, {
                                'Attendance': member.attendance,
                              });
                            }
                          },
                          color: Theme.of(context).buttonColor,
                          iconColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
