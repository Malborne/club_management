import 'package:club_management/components/my_icons.dart';
import 'package:club_management/screens/add_sessions_screen.dart';
import 'package:club_management/utility/member.dart';
import 'package:club_management/utility/networking.dart';
import 'package:club_management/utility/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:club_management/utility/constants.dart';
import 'package:club_management/components/text_bubble.dart';
import 'dart:math';

// Create a Form widget.
class AddMember extends StatefulWidget {
  final List<Member> members;
  final List<Session> sessions;
  final Member currentMember;

  AddMember(
      {@required this.members, @required this.sessions, this.currentMember});
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final _formKey = GlobalKey<FormState>();
  String firstName;
  String lastName;
  String arabicFirst;
  String arabicLast;
  String email;
  int rank = 0;
  bool isCardPrinted = false;
  bool isCardReceived = false;
  List<Session> attendedSessions = [];

  @override
  void initState() {
    super.initState();
    if (widget.currentMember == null) {
    } else {
      firstName = widget.currentMember.firstName;
      lastName = widget.currentMember.lastName;
      arabicFirst = widget.currentMember.arabicFirst;
      arabicLast = widget.currentMember.arabicLast;
      email = widget.currentMember.email;
      rank = widget.currentMember.rank;
      isCardPrinted = widget.currentMember.isCardPrinted;
      isCardReceived = widget.currentMember.isCardReceived;
      attendedSessions.addAll(
          getAttendance(widget.currentMember.attendance, widget.sessions));
    }
  }

  CupertinoPicker iOSPicker() {
    List<Text> items = [];
    for (String rank in EnglishRanks) {
      items.add(
        Text(
          rank,
          style: TextStyle(color: Colors.black),
        ),
      );
    }
    return CupertinoPicker(
      itemExtent: 10,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      onSelectedItemChanged: (selectedIndex) {
        print(EnglishRanks[selectedIndex]);
        setState(() {
          rank = selectedIndex;
        });
      },
      children: items,
    );
  }

  DropdownButton<String> androidDropDownButton() {
    List<DropdownMenuItem<String>> dropDownMenus = [];
    for (String rank in EnglishRanks) {
      dropDownMenus.add(
        DropdownMenuItem(
          child: Text(rank),
          value: rank,
        ),
      );
    }

    return DropdownButton<String>(
      value: EnglishRanks[rank],
//      focusColor: Theme.of(context).bottomAppBarColor,
//      iconEnabledColor: Theme.of(context).bottomAppBarColor,
      items: dropDownMenus,
      onChanged: (value) {
        setState(() {
          rank = EnglishRanks.indexOf(value);
        });
      },
    );
  }

  List<Widget> addSessions() {
    List<Widget> participantWidgets = [];
    for (Session session in attendedSessions) {
      participantWidgets.add(
        TextBubble(
          text: '${session.title}',
        ),
      );
    }
    return participantWidgets;
  }

  String generateCode() {
    String code;
    do {
      code = '';
      for (int i = 0; i < 12; i++) code += Random().nextInt(10).toString();
    } while (widget.members.contains(code));
    return code;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.currentMember == null ? 'Add a new member' : 'Edit member',
        ),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              String code = widget.currentMember == null ||
                      widget.currentMember.code == null
                  ? generateCode()
                  : widget.currentMember.code;
              if (_formKey.currentState.validate()) {
                Member newMember = Member(
                  firstName: firstName,
                  lastName: lastName,
                  arabicFirst: arabicFirst,
                  arabicLast: arabicLast,
                  email: email,
                  rank: rank,
                  isCardPrinted: isCardPrinted,
                  isCardReceived: isCardReceived,
                  attendance: attendedSessions
                      .map((session) => session.code.toString())
                      .toList(),
                  code: code,
                );
                Navigator.pop(context, newMember);
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
                        hintText: 'The first name of the participant',
                        labelText: 'First Name',
                      ),
                      onChanged: (value) {
                        firstName = value;
                      },
                      initialValue: widget.currentMember != null
                          ? widget.currentMember.firstName
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
                          Icons.title,
                          size: 28,
                        ),
                        hintText: 'The last name of the particiapnt',
                        labelText: 'Last Name',
                      ),
                      style: kInputFieldStyle,
                      onChanged: (value) {
                        lastName = value;
                      },
                      initialValue: widget.currentMember != null
                          ? widget.currentMember.lastName
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
                        icon: Icon(MyIcons.arabic
//                        size: 28,
                            ),
                        hintText: 'The first name in Arabic',
                        labelText: 'Arabic First Name',
                      ),
                      onChanged: (value) {
                        arabicFirst = value;
                      },
                      initialValue: widget.currentMember != null
                          ? widget.currentMember.arabicFirst
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
                        icon: Icon(MyIcons.arabic
//                        size: 28,
                            ),
                        hintText: 'The last name in Arabic',
                        labelText: 'Arabic Last Name',
                      ),
                      onChanged: (value) {
                        arabicLast = value;
                      },
                      initialValue: widget.currentMember != null
                          ? widget.currentMember.arabicLast
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
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email
//                        size: 28,
                            ),
                        hintText: 'The participant\'s email',
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                      initialValue: widget.currentMember != null
                          ? widget.currentMember.email
                          : '',
                      style: kInputFieldStyle,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 10, left: 1),
                      leading: Icon(
                        Icons.star,
                        size: 28,
                      ),
                      title: Text(
                        'Rank',
                        style: kInputFieldStyle,
                      ),
                      trailing: androidDropDownButton(),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 10, left: 1),
                      leading: Icon(Icons.help_outline),
                      title: Text(
                        'Is the Card Printed?',
                        style: kInputFieldStyle,
                      ),
                      trailing: Switch(
                        value: isCardPrinted,
                        onChanged: (bool s) => isCardPrinted = s,
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(right: 10, left: 1),
                      leading: Icon(Icons.help_outline),
                      title: Text(
                        'Is the Card Received?',
                        style: kInputFieldStyle,
                      ),
                      trailing: Switch(
                        value: isCardReceived,
                        onChanged: (bool s) => isCardReceived = s,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () async {
                        List<dynamic> selectedSessions = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddSessionsScreen(
                                    sessions: widget.sessions,
                                    previouslySelected: attendedSessions)));

                        if (selectedSessions != null) {
                          setState(() {
                            attendedSessions = selectedSessions;
                          });
                        }
                      },
                      leading: Icon(
                        Icons.people,
                        size: 28,
                      ),
                      contentPadding: EdgeInsets.only(right: 8, left: 3),
                      title: Text(
                        'Attended Sessions',
                        style: kInputFieldStyle,
                      ),
                      trailing: Icon(Icons.add),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      children: addSessions(),
                    ),
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
