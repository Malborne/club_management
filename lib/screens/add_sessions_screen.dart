import 'package:club_management/components/my_icons.dart';
import 'package:club_management/utility/session.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
//import 'package:club_management/utility/constants.dart';

class AddSessionsScreen extends StatefulWidget {
  final List<Session> sessions;
  final List<Session> previouslySelected;
  AddSessionsScreen({@required this.sessions, this.previouslySelected});
  @override
  _AddSessionsScreenState createState() => _AddSessionsScreenState();
}

class _AddSessionsScreenState extends State<AddSessionsScreen> {
  List<Session> selectedSessions = [];

  @override
  void initState() {
    super.initState();
    if (widget.previouslySelected != null) {
      selectedSessions.addAll(widget.previouslySelected);
    }
  }

  List<Widget> createSessions() {
    List<Widget> sessionsWidgets = [];

    for (Session session in widget.sessions) {
      if (session.hashCode ==
          widget.sessions[widget.sessions.length - 1].hashCode) {
        sessionsWidgets.add(
          ListTile(
            onTap: () {
              if (!isSelected(session)) {
                setState(() {
                  selectedSessions.add(session);
                });
              } else {
                setState(() {
                  selectedSessions.remove(session);
                });
              }
            },
            title: Text('${session.title}'),
            subtitle: Text(
              DateFormat('EEE, MMM d yyyy').format(session.date),
            ),
            trailing: IconButton(
              icon: Icon(isSelected(session)
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onPressed: () {
                if (!isSelected(session)) {
                  setState(() {
                    selectedSessions.add(session);
                  });
                } else {
                  setState(() {
                    selectedSessions.remove(session);
                  });
                }
              },
            ),
          ),
        );
      } else {
        sessionsWidgets.add(
          Column(
            children: [
              ListTile(
                onTap: () {
                  if (!isSelected(session)) {
                    setState(() {
                      selectedSessions.add(session);
                    });
                  } else {
                    setState(() {
                      selectedSessions.remove(session);
                    });
                  }
                },
                title: Text('${session.title}'),
                subtitle: Text(
                  DateFormat('EEE, MMM d yyyy').format(session.date),
                ),
                trailing: IconButton(
                  icon: Icon(isSelected(session)
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                  onPressed: () {
                    if (!isSelected(session)) {
                      setState(() {
                        selectedSessions.add(session);
                      });
                    } else {
                      setState(() {
                        selectedSessions.remove(session);
                      });
                    }
                  },
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
                height: 1,
                indent: 20,
                endIndent: 20,
              ),
            ],
          ),
        );
      }
    }

    return sessionsWidgets;
  }

  bool isSelected(Session session) {
    if (selectedSessions.contains(session))
      return true;
    else
      return false;
  }

  String selectedTitle() {
    if (selectedSessions.length == 0)
      return 'None Selected';
    else if (selectedSessions.length == 1)
      return '1 Session Selected';
    else
      return '${selectedSessions.length} Sessions Selected';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedTitle()),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, selectedSessions);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: createSessions(),
            ),
          ),
          Material(
            elevation: 5,
            color: Theme.of(context).bottomAppBarColor,
            child: Container(
                alignment: Alignment.center,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      if (selectedSessions.length != widget.sessions.length) {
                        selectedSessions = [];
                        selectedSessions.addAll(widget.sessions);
                      } else
                        selectedSessions = [];
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Icon(
                          selectedSessions.length != widget.sessions.length
                              ? MyIcons.select_all
                              : MyIcons.deselect_all,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          selectedSessions.length != widget.sessions.length
                              ? 'Select all'
                              : 'Deselect all',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
