import 'package:club_management/screens/add_members_screen.dart';
import 'package:club_management/utility/member.dart';
import 'package:club_management/utility/networking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:club_management/utility/constants.dart';
import 'package:club_management/utility/session.dart';
import 'package:uuid/uuid.dart';
import 'package:club_management/components/text_bubble.dart';

// Create a Form widget.
class AddSession extends StatefulWidget {
  final List<Member> members;
  final Session currentSession;

  AddSession({@required this.members, this.currentSession});
  @override
  _AddSessionState createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  final _formKey = GlobalKey<FormState>();
  List<Member> sessionParticipants = [];
  String title;
  String location;
  String room;
  DateTime date;
  TimeOfDay beginTime;
  TimeOfDay endTime;
  bool isBeforeBeginTime = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentSession == null) {
      date = DateTime.now();
      beginTime = TimeOfDay(hour: 16, minute: 30);
      endTime = TimeOfDay(hour: 18, minute: 30);
    } else {
      title = widget.currentSession.title;
      location = widget.currentSession.location;
      room = widget.currentSession.room;
      date = widget.currentSession.date;
      beginTime = widget.currentSession.beginTime;
      endTime = widget.currentSession.endTime;
      sessionParticipants.addAll(
          getAttendees(widget.currentSession.attendees, widget.members));
    }
  }

  Future<Null> selectDate(context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2022),
    );

    if (picked != null && picked != date) {
      print('date Selected ${date.toString()}');
      setState(() {
        date = picked;
      });
    }
  }

  Future<Null> selectTime(context, bool isBegin) async {
    TimeOfDay timeOfDay = isBegin ? beginTime : endTime;
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (picked != null) {
      print('date Selected ${timeOfDay.toString()}');
      setState(() {
        if (isBegin)
          beginTime = picked;
        else if (!isBegin &&
            (picked.hour * 60 + picked.minute) <
                (beginTime.hour * 60 + beginTime.minute)) {
          isBeforeBeginTime = true;
          endTime = picked;
        } else {
          isBeforeBeginTime = false;
          endTime = picked;
        }
      });
    }
  }

  List<Widget> addMembers() {
    List<Widget> participantWidgets = [];
    for (Member Part in sessionParticipants) {
      participantWidgets.add(
        TextBubble(
          text: '${Part.firstName} ${Part.lastName}',
        ),
      );
    }
    return participantWidgets;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.currentSession == null ? 'Add a new Session' : 'Edit session',
        ),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              var code = widget.currentSession != null
                  ? widget.currentSession.code
                  : Uuid().v4();
              if (_formKey.currentState.validate() && !isBeforeBeginTime) {
                Session newSession = Session(
                    title: title,
                    date: date,
                    attendees: sessionParticipants
                        .map((member) => member.code.toString())
                        .toList(),
                    code: code,
                    beginTime: beginTime,
                    endTime: endTime,
                    location: location,
                    room: room);
                Navigator.pop(context, newSession);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.title,
                          size: 28,
                        ),
                        hintText: 'What is the title of the session?',
                        labelText: 'Title',
                      ),
                      onChanged: (value) {
                        title = value;
                      },
                      initialValue: widget.currentSession != null
                          ? widget.currentSession.title
                          : '',
                      style: kInputFieldStyle,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.location_on,
                          size: 28,
                        ),
                        hintText: 'Where is the session held at?',
                        labelText: 'Location',
                      ),
//                initialValue: 'Enter the Name of the Session',
                      style: kInputFieldStyle,
                      onChanged: (value) {
                        location = value;
                      },
                      initialValue: widget.currentSession != null
                          ? widget.currentSession.location
                          : '',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(
                          FontAwesomeIcons.doorOpen,
//                        size: 28,
                        ),
                        hintText: 'Which Room is the session held at',
                        labelText: 'Room',
                      ),
                      onChanged: (value) {
                        room = value;
                      },
                      initialValue: widget.currentSession != null
                          ? widget.currentSession.room
                          : '',
                      style: kInputFieldStyle,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        selectDate(context);
                      },
                      leading: Icon(
                        Icons.date_range,
                        size: 28,
//                      color: Colors.purple,
                      ),
                      contentPadding: EdgeInsets.only(right: 8),
                      title: Text(
                        'Date',
                        style: kInputFieldStyle,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                                DateFormat('EEE, MMM d yyyy').format(date)),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                      indent: 40,
                    ),
                    ListTile(
                      onTap: () {
                        selectTime(context, true);
                      },
                      leading: Icon(
                        Icons.access_time,
                        size: 28,
//                      color: Colors.purple,
                      ),
                      contentPadding: EdgeInsets.only(right: 8),
                      title: Text(
                        'Start',
                        style: kInputFieldStyle,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text('${beginTime.format(context)}'),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 1,
                      indent: 40,
                    ),
                    ListTile(
                      onTap: () {
                        selectTime(context, false);
                      },
                      leading: Icon(
                        Icons.access_time,
                        size: 28,
                        color: isBeforeBeginTime
                            ? Theme.of(context).errorColor
                            : null,
//                      color: Colors.purple,
                      ),
                      contentPadding: EdgeInsets.only(right: 8),
                      title: Text(
                        'End',
                        style: kInputFieldStyle.copyWith(
                            color: isBeforeBeginTime
                                ? Theme.of(context).errorColor
                                : null),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '${endTime.format(context)}',
                              style: TextStyle(
                                  color: isBeforeBeginTime
                                      ? Theme.of(context).errorColor
                                      : null),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 18,
                              color: isBeforeBeginTime
                                  ? Theme.of(context).errorColor
                                  : null)
                        ],
                      ),
                    ),
//                    Divider(
//                      color: Colors.grey,
//                      height: 1,
//                      thickness: 1,
//                      indent: 40,
//                    ),
                  ],
                ),
              ),
              Text(
                'The End time cannot be before the Start time',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: isBeforeBeginTime
                        ? Theme.of(context).errorColor
                        : Colors.transparent),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () async {
                        List<dynamic> selectedParticipants =
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMembersScreen(
                                          members: widget.members,
                                          previouslySelected:
                                              sessionParticipants,
                                        )));

                        if (selectedParticipants != null) {
                          setState(() {
                            sessionParticipants = selectedParticipants;
                          });
                        }
                      },
                      leading: Icon(
                        Icons.people,
                        size: 28,
                      ),
                      contentPadding: EdgeInsets.only(right: 8, left: 3),
                      title: Text(
                        'Participants',
                        style: kInputFieldStyle,
                      ),
                      trailing: Icon(Icons.add),
                    ),
                    Wrap(direction: Axis.horizontal, children: addMembers()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
