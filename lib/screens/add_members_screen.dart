import 'package:club_management/components/my_icons.dart';
import 'package:club_management/utility/member.dart';
import 'package:flutter/material.dart';
import 'package:club_management/utility/constants.dart';

class AddMembersScreen extends StatefulWidget {
  final List<Member> members;
  final List<Member> previouslySelected;
  AddMembersScreen({@required this.members, this.previouslySelected});
  @override
  _AddMembersScreenState createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  List<Member> selectedMembers = [];

  @override
  void initState() {
    super.initState();
    if (widget.previouslySelected != null) {
      selectedMembers.addAll(widget.previouslySelected);
    }
  }

  List<Widget> createMembers() {
    List<Widget> membersWidgets = [];

    for (Member Part in widget.members) {
      if (Part.hashCode == widget.members[widget.members.length - 1].hashCode) {
        membersWidgets.add(
          ListTile(
            onTap: () {
              if (!isSelected(Part)) {
                setState(() {
                  selectedMembers.add(Part);
                });
              } else {
                setState(() {
                  selectedMembers.remove(Part);
                });
              }
            },
            title: Text('${Part.firstName} ${Part.lastName}'),
            subtitle: Text(EnglishRanks[Part.rank]),
            trailing: IconButton(
              icon: Icon(isSelected(Part)
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onPressed: () {
                if (!isSelected(Part)) {
                  setState(() {
                    selectedMembers.add(Part);
                  });
                } else {
                  setState(() {
                    selectedMembers.remove(Part);
                  });
                }
              },
            ),
          ),
        );
      } else {
        membersWidgets.add(
          Column(
            children: [
              ListTile(
                onTap: () {
                  if (!isSelected(Part)) {
                    setState(() {
                      selectedMembers.add(Part);
                    });
                  } else {
                    setState(() {
                      selectedMembers.remove(Part);
                    });
                  }
                },
                title: Text('${Part.firstName} ${Part.lastName}'),
                subtitle: Text(EnglishRanks[Part.rank]),
                trailing: IconButton(
                  icon: Icon(isSelected(Part)
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                  onPressed: () {
                    if (!isSelected(Part)) {
                      setState(() {
                        selectedMembers.add(Part);
                      });
                    } else {
                      setState(() {
                        selectedMembers.remove(Part);
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

    return membersWidgets;
  }

  bool isSelected(Member part) {
    if (selectedMembers.contains(part))
      return true;
    else
      return false;
  }

  String selectedTitle() {
    if (selectedMembers.length == 0)
      return 'None Selected';
    else if (selectedMembers.length == 1)
      return '1 Member Selected';
    else
      return '${selectedMembers.length} Members Selected';
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
              Navigator.pop(context, selectedMembers);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: createMembers(),
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
                      if (selectedMembers.length != widget.members.length) {
                        selectedMembers = [];
                        selectedMembers.addAll(widget.members);
                      } else
                        selectedMembers = [];
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Icon(
                          selectedMembers.length != widget.members.length
                              ? MyIcons.select_all
                              : MyIcons.deselect_all,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          selectedMembers.length != widget.members.length
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
