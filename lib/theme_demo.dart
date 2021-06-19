import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_localization.dart';

// ignore: must_be_immutable
class ThemeDemo extends StatefulWidget {
  ThemeDemo({
    Key? key,
    required this.counter,
    required this.onPress,
    // required this.changeTheme,
    required this.getAppTheme,
  }) : super(key: key);
  late  int counter;

  final VoidCallback onPress;
  // final Function changeTheme;
  final Function getAppTheme;
  @override
  _ThemeDemoState createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.counter = 0;
  }



  @override
  void dispose() {

    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      //increment the counter
      widget.counter++;
    });
  }

  void onSetAppThemeBrightnessLight() {
    //setting the theme as light
    widget.getAppTheme(Brightness.light);
    // widget.changeTheme(true);
  }

  void onSetAppThemeBrightnessDark() {
    //setting the theme as dark
    widget.getAppTheme(Brightness.dark);
    // widget.changeTheme(false);
  }

  @override
  Widget build(BuildContext context) {
    String? firstText =
        AppLocalizations.of(context)?.translate('firstString').toString();
    String? secondText =
        AppLocalizations.of(context)?.translate('secondString').toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Theme Demo'),
        actions: [
          _buildPopupMenuButton()
        ],
      ),
      body: Center(
        child: _buildColumn(firstText!, context, secondText!),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Column _buildColumn(String firstText, BuildContext context, String secondText) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            // 'You have pushed the button this many times:'
            firstText,
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            '${widget.counter}',
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(
            height: 8.0,
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: widget.onPress,
            child: Text(
              secondText,
              style: TextStyle(fontSize: 20),

            ),
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton() {
    return PopupMenuButton<String>(
          tooltip: 'Change the theme of the app',
          onSelected: (value)
            {

              if(value == 'Dark')
                {
                  onSetAppThemeBrightnessDark();
                }
              else
                {
                  onSetAppThemeBrightnessLight();
                }
            },
        itemBuilder: (BuildContext context) {
          return ['Dark', 'light'].map((option) {
            return PopupMenuItem(value: option, child: Text(option));
          }).toList();
        });
  }

}
