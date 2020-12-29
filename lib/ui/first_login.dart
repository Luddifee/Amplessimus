import '../dsbapi.dart' as dsb;
import '../langs/language.dart';
import '../uilib.dart';
import '../prefs.dart' as prefs;
import '../appinfo.dart';
import 'package:dsbuntis/dsbuntis.dart';
import 'package:flutter/material.dart';
import 'package:schttp/schttp.dart';

import 'home_page.dart';

class FirstLogin extends StatefulWidget {
  FirstLogin();
  @override
  _FirstLoginState createState() => _FirstLoginState();
}

class _FirstLoginState extends State<FirstLogin> {
  bool _loading = false;
  String _error = '';
  bool _hide = true;
  final _usernameFormField = AmpFormField.username;
  final _passwordFormField = AmpFormField.password;

  @override
  Widget build(BuildContext context) {
    if (prefs.classLetter.isEmpty) prefs.classLetter = dsb.letters.first;
    if (prefs.classGrade.isEmpty) prefs.classGrade = dsb.grades.first;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            children: [
              ampTitle(appTitle),
              ampPadding(
                10,
                ampColumn([
                  AutofillGroup(
                    child: ampColumn([
                      _usernameFormField.flutter(),
                      _passwordFormField.flutter(
                        suffixIcon: ampHidePwdBtn(
                            _hide, () => setState(() => _hide = !_hide)),
                        obscureText: _hide,
                      ),
                    ]),
                  ),
                  Divider(),
                  ampWidgetWithText(
                    Language.current.changeLanguage,
                    ampDropdownButton(
                      value: Language.current,
                      itemToDropdownChild: (i) => ampText(i.name),
                      items: Language.all,
                      onChanged: (v) => setState(() => Language.current = v),
                    ),
                  ),
                  Divider(),
                  ampWidgetWithText(
                    Language.current.selectClass,
                    ampRow(
                      [
                        ampDropdownButton(
                          value: prefs.classGrade,
                          items: dsb.grades,
                          onChanged: (v) => setState(prefs.setClassGrade(v)),
                        ),
                        ampPadding(8),
                        ampDropdownButton(
                          value: prefs.classLetter,
                          items: dsb.letters,
                          onChanged: (v) =>
                              setState(() => prefs.classLetter = v),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ampErrorText(_error),
                ]),
              )
            ],
          ),
        ),
        bottomSheet: _loading
            ? LinearProgressIndicator(semanticsLabel: 'Loading')
            : ampNull,
        floatingActionButton: ampFab(
          onPressed: () async {
            setState(() => _loading = true);
            try {
              final user = _usernameFormField.text.trim();
              final pass = _passwordFormField.text.trim();
              prefs.username = user;
              prefs.password = pass;
              final error = await checkCredentials(user, pass, http.post);
              if (error != null) throw Language.current.dsbError(error);

              await dsb.updateWidget();

              setState(() {
                _loading = false;
                _error = '';
              });

              prefs.firstLogin = false;
              return ampChangeScreen(AmpHomePage(0), context);
            } catch (e) {
              setState(() {
                _loading = false;
                _error = e;
              });
            }
          },
          label: Language.current.save,
          iconDefault: Icons.save,
          iconOutlined: Icons.save_outlined,
        ),
      ),
    );
  }
}

final cachedHttpGet = ScHttpClient(prefs.getCache, prefs.setCache).get;
final http = ScHttpClient();
