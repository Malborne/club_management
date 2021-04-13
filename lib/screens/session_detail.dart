import 'package:club_management/screens/add_members_screen.dart';
import 'package:club_management/utility/member.dart';
import 'package:club_management/utility/networking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:club_management/utility/session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:club_management/components/my_icon_button.dart';
import 'package:club_management/components/my_icons.dart';
import 'package:club_management/screens/add_session.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

class SessionDetail extends StatefulWidget {
  final members;
  final sessionColor;
  final List<Session> sessions;
  final Session session;
  SessionDetail(
      {@required this.session,
      this.sessionColor,
      @required this.members,
      @required this.sessions});
  @override
  _SessionDetailState createState() => _SessionDetailState();
}

class _SessionDetailState extends State<SessionDetail> {
  String title;
  Session session;

  @override
  void initState() {
    super.initState();
    session = widget.session;
  }

  String membersNumberText() {
    if (session.attendees.length == 0)
      return 'Nobody went';
    else if (session.attendees.length == 1)
      return 'One person went';
    else
      return '${session.attendees.length} People Went';
  }

  void editSession() async {
    var editedSession = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddSession(
            members: widget.members,
            currentSession: session,
          ),
        ));
    if (editedSession != null) {
      setState(() {
        widget.sessions[widget.sessions.indexOf(session)] = editedSession;
        session = editedSession;
        //TODO handle all the exceptions

        updateSessionFirestore(session.code, {
          'Name': session.title,
          'Attendees': session.attendees,
          'BeginTime': (session.date.millisecondsSinceEpoch / 1000),
          'EndTime':
              (session.date.add(session.getDuration()).millisecondsSinceEpoch /
                  1000),
          'Location': session.location,
          'Room': session.room
        });

        print('Session data updated');
      });
    }
  }

  Future<void> deleteSession() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Session'),
          content: Text(
              'Are you sure you want to permenantly delete this session?.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                // implement delete session
                widget.sessions.remove(session);
                //deleting the session from firestore
                deleteSessionFirestore(session.code);

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

  Future<void> scanBarcode() async {
    try {
      String result = await BarcodeScanner.scan();

      if (result != null && result != '') {
        Member scannedMember = widget.members
            .firstWhere((member) => member.code == result, orElse: () {
          Fluttertoast.showToast(
              msg: "Member not found in the database",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 14.0);
        });
        print(scannedMember);

        if (scannedMember != null) {
          if (!session.attendees.contains(scannedMember.code)) {
            setState(() {
              session.attendees.add(scannedMember.code);
            });
            if (await Vibration.hasVibrator()) {
              Vibration.vibrate(duration: 100);
            }
            Fluttertoast.showToast(
                msg: "Member added successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 14.0);

            print('Member added successfully');
          } else {
            Fluttertoast.showToast(
                msg: "Member already added to the session",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: "Member not found in the database",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    } catch (e) {
      print(e); //TODO handle the exceptions appropriately
    }
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
            backgroundColor: widget.sessionColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 43, bottom: 20),
              title: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  session.title,
//                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: editSession,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
                onPressed: deleteSession,
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
//                Padding(
//                  padding: const EdgeInsets.symmetric(
//                      horizontal: 10.0, vertical: 20),
//                  child: FittedBox(
//                    fit: BoxFit.fitWidth,
//                    child: Text(
//                      session.title,
//                      style: TextStyle(
//                          fontSize: 28,
//                          fontWeight: FontWeight.bold,
//                          color: Colors.black),
//                    ),
//                  ),
//                ),
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.access_time,
                          size: 28,
                        ),
                        title: Text(
                            DateFormat('EEE, MMM d yyyy').format(session.date)),
                        subtitle: Text(
                            '${session.beginTime.format(context)} - ${session.endTime.format(context)}'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.location_on,
                          size: 28,
                        ),
                        title: Text(session.location),
                        subtitle: Text(session.room),
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
                    children: session.getMembers(members: widget.members),
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
//              height: double.infinity,
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
                          onPressed: editSession,
                          color: Colors.transparent,
                          iconColor: Theme.of(context).buttonColor,
                        ),
                        MyIconButton(
                          icon: MyIcons.scan,
                          size: 40,
                          shape: BeveledRectangleBorder(),
                          onPressed: scanBarcode,
                          color: Colors.transparent,
                          iconColor: Theme.of(context).buttonColor,
                        ),
                        MyIconButton(
                            icon: FontAwesomeIcons.plus,
                            size: 24,
                            buttonSize: 48,
                            shape: CircleBorder(),
                            onPressed: () async {
                              List<dynamic> selectedParticipants =
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddMembersScreen(
                                                members: widget.members,
                                                previouslySelected:
                                                    getAttendees(
                                                        session.attendees,
                                                        widget.members),
                                              )));
                              if (selectedParticipants != null) {
                                session.attendees = selectedParticipants
                                    .map((member) => member.code)
                                    .toList();
                                //TODO handle all the exceptions
                                updateSessionFirestore(session.code, {
                                  'Attendees': session.attendees
                                      .map((member) => member.code.toString())
                                      .toList(),
                                });
                              }
                            },
                            color: Theme.of(context).buttonColor,
                            iconColor: Colors.white),
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
