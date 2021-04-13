import 'package:club_management/screens/member_detail.dart';
import 'package:club_management/screens/session_detail.dart';
import 'package:flutter/material.dart';
import 'package:club_management/utility/session.dart';
import 'package:club_management/utility/member.dart';

class DataSearch extends SearchDelegate<String> {
  final recentList = [];
//  List searchObjects;
  bool searchSessions;
  List<Session> sessions;
  List<Member> members;
  List<String> dataList;

  DataSearch(
      {@required this.sessions,
      @required this.members,
      @required this.searchSessions,
      @required this.dataList})
      : super(
          searchFieldLabel:
              searchSessions ? 'Search for Sessions' : 'Search for Members',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

//  {
//    super(
//      searchFieldLabel: 'Search for Sessions',
//      keyboardType: TextInputType.text,
//      textInputAction: TextInputAction.search,
//    );
//    this.sessions = sessions;
//    this.members = members;
//    this.searchSessions = searchSessions;
//    getDataList();
//  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; //clear the query
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentList
        : dataList.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionList[index];
          var result = searchSessions
              ? sessions.where((session) => session.title == query).first
              : members
                  .where((member) =>
                      ('${member.firstName} ${member.lastName}' == query) ||
                      ('${member.arabicFirst} ${member.arabicLast}' == query))
                  .first;

          if (result is Session && result != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SessionDetail(
                          sessions: sessions,
                          members: members,
                          session: result,
                        )));
          } else if (result is Member && result != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MemberDetail(
                          sessions: sessions,
                          members: members,
                          member: result,
                        )));
          }
        },
        leading:
            Icon(query.isEmpty ? Icons.settings_backup_restore : Icons.search),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.body1.color),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }
}
