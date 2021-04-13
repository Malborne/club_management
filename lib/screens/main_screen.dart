import 'package:club_management/screens/add_member.dart';
import 'package:club_management/screens/sessions_tab.dart';
import 'package:club_management/screens/members_tab.dart';
import 'package:club_management/screens/settings_screen.dart';
import 'package:club_management/utility/data_search.dart';
import 'package:club_management/utility/member.dart';
import 'package:club_management/utility/networking.dart';
import 'package:club_management/utility/shared_prefrences_helper.dart';
import 'package:flutter/material.dart';
import 'package:club_management/utility/session.dart';
import 'add_session.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:club_management/utility/Themes/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//const List<Choice> choices = const <Choice>[
//  const Choice(title: 'About', icon: Icons.info),
//  const Choice(title: 'Settings', icon: Icons.settings),
//];

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Session> sessions;
  List<Member> members;
  bool showSpinner = false;

  void getData() async {
    setState(() {
      showSpinner = true;
    });
    var appTheme = await SharedPreferencesHelper.getAppTheme();
    if (appTheme == null)
      appTheme = MediaQuery.of(context).platformBrightness == Brightness.light
          ? 'PurpleLight'
          : 'PurpleDark';
    BlocProvider.of<ThemeBloc>(context).dispatch(ThemeChanged(theme: appTheme));
    sessions = await fetchInitialSessions();
    members = await fetchInitialMembers();
    setState(() {
      showSpinner = false;
    });
  }

  List<String> getSearchList(bool searchSessions) {
    List<String> dataList = [];
    if (searchSessions) {
      for (Session session in sessions) {
        dataList.add(session.title);
      }
    } else {
      for (Member member in members) {
        dataList.add('${member.firstName} ${member.lastName}');
        dataList.add('${member.arabicFirst} ${member.arabicLast}');
      }
    }
    return dataList;
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    getData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(
                      searchSessions: _tabController.index == 0 ? true : false,
                      dataList: getSearchList(
                          _tabController.index == 0 ? true : false),
                      sessions: sessions,
                      members: members,
                    ));
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ),
            ),
            // action button
//            PopupMenuButton<Choice>(
//              onSelected: (choice) => Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => SettingsScreen(),
//                  )),
//              itemBuilder: (BuildContext context) {
//                return choices.map((Choice choice) {
//                  return PopupMenuItem<Choice>(
//                    value: choice,
//                    child: Text(choice.title),
//                  );
//                }).toList();
//              },
//            ),
          ],
          // overflow menu
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: 'Sessions',
              ),
              Tab(
                text: 'Members',
              ),
            ],
          ),
          title: Text('Club Management'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: showSpinner
                  ? Container()
                  : SessionsTab(
                      sessions: sessions,
                      members: members,
                    ),
            ),
            ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: showSpinner
                  ? Container()
                  : MembersTab(
                      members: members,
                      sessions: sessions,
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_tabController.index == 0) {
              //On the sessions tab
              var newSession = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSession(
                      members: members,
                    ),
                  ));

              if (newSession != null) {
                setState(() {
                  sessions.add(newSession);
//                print('Sessions: ${sessions.length}');
                  //Adding the session to firestore
                  addSessionFirestore(newSession);
                });
              }
            } else {
              //On the members tab
              var newMember = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMember(
                      sessions: sessions,
                      members: members,
                    ),
                  ));

              if (newMember != null) {
                setState(() {
                  members.add(newMember);

                  //Adding the member to firestore
                  addMemberFirestore(newMember);
                });
              }
            }
          },
          backgroundColor: Theme.of(context).buttonColor,
          tooltip: 'Increment',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
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
