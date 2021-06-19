import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_demo.dart';
import 'app_localization.dart';

void main()
{
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  var _supportedLocalesList = [
    //these are the languages we want to implement in app
    //you need to setup a json file for language
    Locale('en', 'US'),
    Locale('es', 'ES'),
  ];
  var _localizationsDelegatesList = [
    //this is modified app localization delegate
    AppLocalizations.delegate,
    //import flutter localization
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate


  ];

  late Future _lightF;//future value of bool that will stored as shared preferences
  bool isThemeFromApp = false;
  ThemeData _darkTheme = ThemeData(
      accentColor: Colors.tealAccent,
      brightness: Brightness.dark,
      primaryColor: Colors.amber,
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber, disabledColor: Colors.black));
  ThemeData _lightTheme = ThemeData(
      accentColor: Colors.pink,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber, disabledColor: Colors.white));

  int counter = 0;
  var platformBrightness; //platform brightness from device

  void resetCounter() {
    //reset the counter to 0
    setState(() {
      counter = 0;
    });
  }

  void onToggle(bool toggle) async {
    //function that toggle the theme of the app from dark to light and vice versa
    // print('Toggle Theme function is called');
    setState(() {
    });
  }

  void getSystemBrightness(Brightness brightness) {
    //get the theme from system
    setState(() {
      platformBrightness = brightness;
      if (platformBrightness == Brightness.light) {
        isThemeFromApp = true;
      } else {
        isThemeFromApp = false;
      }
    });
  }

  void getAppBrightness(Brightness appThemeBrightness) {
    //this method get brightness from user
    setState(() {
      platformBrightness = appThemeBrightness;
      if (platformBrightness == Brightness.light) {
        isThemeFromApp = true;
        // saving the theme as user preferences
        _saveTheme();
      } else {
        isThemeFromApp = false;
        //saving the theme as user preferences
        _saveTheme();
      }
    });
  }
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _saveTheme() async {
    //method that saved the theme selected by user

    SharedPreferences pref = await _prefs;
    pref.setBool('theme', isThemeFromApp);
  }

  _getTheme() async {
    //returns the saved theme
    _lightF = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') != null ? prefs.getBool('theme') : true;
    });
    isThemeFromApp = await _lightF;
  }


  void initState() {
    super.initState();
    //this will helps to interact and listen changes in device
    WidgetsBinding.instance!.addObserver(this);
    _getTheme();

  }

  void didChangePlatformBrightness() {
    //this method listen the changes in brightness of device
    final Brightness brightness =
        WidgetsBinding.instance!.window.platformBrightness;
    //inform listeners and rebuild widget tree
    getSystemBrightness(brightness);

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _lightF,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            supportedLocales: _supportedLocalesList,

            localizationsDelegates: _localizationsDelegatesList,

            localeResolutionCallback: _userLocalResolutionCallBack,
            //if isThemeFromApp is true it selects light theme else dark theme
            theme: isThemeFromApp ? _lightTheme : _darkTheme,

            title: 'Flutter LifeCycle Demos',
            home: ThemeDemo(

              counter: counter,//counter for increment
              onPress: resetCounter, //function for reset counter
              // changeTheme: onToggle, //function for toggle the theme
              getAppTheme: getAppBrightness,//getting current theme of app
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Locale _userLocalResolutionCallBack(locale, supportedLocales) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale!.languageCode &&
            supportedLocale.countryCode == locale.countryCode) {
          return supportedLocale;
        }
      }

      return supportedLocales.first;
    }
}
