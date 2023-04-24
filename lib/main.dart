import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeedit_parser/screens/main_page.dart';
import 'package:timeedit_parser/utilities/theming.dart';
import 'package:timeedit_parser/utilities/settings.dart' as settings;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(TimeEditParser());
  settings.getSettings();
}

class TimeEditParser extends StatelessWidget {
  @override
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Theming>(
        create: (_) => Theming(),
        child: Consumer<Theming>(
            builder: (_, model, __) => MaterialApp(
                  title: 'TimeEdit Parser',
                  theme:
                      ThemeData(brightness: Brightness.light, primarySwatch: Colors.orange, splashColor: Colors.grey),
                  darkTheme: ThemeData(
                      brightness: Brightness.dark, primarySwatch: Colors.orange, scaffoldBackgroundColor: Colors.black),
                  themeMode: model.getCurrentTheme(),
                  home: MainPage(theming: model),
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en', ''), // English, no country code
                    Locale('sv', ''), // Swedish, no country code
                  ],
                )));
  }
}
