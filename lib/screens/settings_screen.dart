import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:club_management/utility/Themes/bloc/bloc.dart';
import 'package:club_management/utility/shared_prefrences_helper.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<bool> selections = List.generate(3, (_) => false);

  void getInitialTheme() async {
    String theme = await SharedPreferencesHelper.getAppTheme();
    if (theme == null) {
      MediaQuery.of(context).platformBrightness == Brightness.light
          ? selections[0] = true
          : selections[2] = true;
    } else {
      if (theme == 'PurpleLight')
        setState(() {
          selections[0] = true;
        });
      else if (theme == 'PurpleDark')
        setState(() {
          selections[1] = true;
        });
      else if (theme == 'DarkNormal')
        setState(() {
          selections[2] = true;
        });
    }
  }

  @override
  void initState() {
    getInitialTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'App Theme',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            color: !selections[0]
                ? Theme.of(context).buttonColor
                : Theme.of(context).disabledColor,
            child: ListTile(
              title: Text(
                'Light Theme',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: !selections[0]
                  ? () {
                      BlocProvider.of<ThemeBloc>(context)
                          .dispatch(ThemeChanged(theme: 'PurpleLight'));
                      SharedPreferencesHelper.setAppTheme(('PurpleLight'));
                      setState(() {
                        selections[0] = true;
                        selections[1] = false;
                        selections[2] = false;
                      });
                    }
                  : null,
            ),
          ),
          Card(
            color: !selections[1]
                ? Theme.of(context).buttonColor
                : Theme.of(context).disabledColor,
            child: ListTile(
              title: Text(
                'Purple Dark Theme',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: !selections[1]
                  ? () {
                      BlocProvider.of<ThemeBloc>(context)
                          .dispatch(ThemeChanged(theme: 'PurpleDark'));
                      SharedPreferencesHelper.setAppTheme(('PurpleDark'));
                      setState(() {
                        selections[0] = false;
                        selections[1] = true;
                        selections[2] = false;
                      });
                    }
                  : null,
            ),
          ),
          Card(
            color: !selections[2]
                ? Theme.of(context).buttonColor
                : Theme.of(context).disabledColor,
            child: ListTile(
              title: Text(
                'Normal Dark Theme',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: !selections[2]
                  ? () {
                      BlocProvider.of<ThemeBloc>(context)
                          .dispatch(ThemeChanged(theme: 'DarkNormal'));
                      SharedPreferencesHelper.setAppTheme(('DarkNormal'));
                      setState(() {
                        selections[0] = false;
                        selections[1] = false;
                        selections[2] = true;
                      });
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
