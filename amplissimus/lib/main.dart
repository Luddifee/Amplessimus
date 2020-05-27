import 'package:amplissimus/animations.dart';
import 'package:amplissimus/dsbapi.dart';
import 'package:amplissimus/logging.dart';
import 'package:amplissimus/prefs.dart';
import 'package:amplissimus/values.dart';
import 'package:amplissimus/widgets.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(SplashScreen());
}
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Prefs.loadPrefs();
    return MaterialApp(home: SplashScreenPage());
  }
}
class SplashScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {return SplashScreenPageState();}
}
class SplashScreenPageState extends State<SplashScreenPage> {
  VideoPlayerController videoController = VideoPlayerController.asset('assets/videos/amplissimus.mp4');

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 10), () {
      videoController.play();
      ampLog(ctx: 'SplashScreen', message: 'playing video');
      Future.delayed(Duration(milliseconds: 1000), () {
        Animations.changeScreenEaseOutBack(new MyApp(initialIndex: 0,), context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    videoController.initialize();
    return Scaffold(
      body: Center(
        child: AspectRatio(aspectRatio: 16/9, child: VideoPlayer(videoController)),
      ),
      backgroundColor: Color.fromRGBO(210, 210, 210, 1),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({this.initialIndex});
  int initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    ampLog(ctx: 'MyApp', message: 'Building Main Page');
    return WillPopScope(
      child: MaterialApp(
        title: AmpStrings.appTitle,
        theme: ThemeData(
          primarySwatch: AmpColors.primaryBlack,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: AmpStrings.appTitle, textStyle: TextStyle(color: AmpColors.colorForeground), 
          initialIndex: initialIndex,),
      ), 
      onWillPop: () {
        Animations.changeScreenNoAnimation(this, context);
        return new Future(() => false);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.textStyle, @required this.initialIndex}) : super(key: key);
  final int initialIndex;
  final String title;
  final TextStyle textStyle;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int _counter = Prefs.counter;

  void _incrementCounter() {
    setState(() {
      _counter = Prefs.counter;
      _counter++;
      _counter++;
      Prefs.saveCounter(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> containers = [
      Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have pushed the button this many times:', style: widget.textStyle),
              Text('$_counter', style: TextStyle(color: AmpColors.colorForeground, fontSize: 30)),
              RaisedButton(
                child: Text('chrissx sucht hart'),
                onPressed: () async {
                  Animations.changeScreenEaseOutBack(Klasse(await dsbGetWidget()), context);
                }
              ),
              ListTile(
                title: Text('3.Stunde Sport', style: widget.textStyle),
                subtitle: Text('Vertretung durch Juppi_S', style: widget.textStyle),
              ),
              Divider(color: AmpColors.colorForeground,),
              ListTile(
                title: Text('3.Stunde Sport', style: widget.textStyle),
                subtitle: Text('Vertretung durch Juppi_S', style: widget.textStyle),
              ),
              Divider(color: AmpColors.colorForeground,),
              ListTile(
                title: Text('3.Stunde Sport', style: widget.textStyle),
                subtitle: Text('Vertretung durch Juppi_S', style: widget.textStyle),
              ),
              Divider(color: AmpColors.colorForeground,),
            ],
          ),
        ),
      ),
      Container(
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(32.0),),),
              color: AmpColors.colorBackground,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                customBorder: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(32.0),),),
                onTap: () {
                  AmpColors.changeMode();
                  Animations.changeScreenNoAnimation(new MyApp(initialIndex: 1,), context);
                },
                child: Widgets.toggleDarkModeWidget(AmpColors.isDarkMode, widget.textStyle),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(32.0),),),
              color: AmpColors.colorBackground,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                customBorder: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(32.0),),),
                onTap: () {
                  Widgets.showInputEntryCredentials(context);
                },
                child: Widgets.entryCredentialsWidget(AmpColors.isDarkMode, widget.textStyle),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(32.0),),),
              color: AmpColors.colorBackground,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                customBorder: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(32.0),),),
                onTap: () {
                  Widgets.showInputSelectCurrentClass(context);
                },
                child: Widgets.setCurrentClassWidget(AmpColors.isDarkMode, widget.textStyle),
              ),
            ),
          ],
        ),
      )
    ];
    return DefaultTabController(length: 2, initialIndex: widget.initialIndex,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AmpColors.colorBackground,
          body: TabBarView(
            physics: ClampingScrollPhysics(),
            children: containers,
          ),
          floatingActionButton: FloatingActionButton.extended(
            hoverColor: AmpColors.colorForeground,
            elevation: 0,
            backgroundColor: AmpColors.colorBackground,
            splashColor: AmpColors.colorForeground,
            onPressed: _incrementCounter,
            icon: Icon(Icons.add, color: AmpColors.colorForeground,),
            label: Text('Zählen', style: widget.textStyle,),
          ),
          bottomNavigationBar: SizedBox(
            height: 55,
            child: TabBar(
              indicatorColor: AmpColors.colorForeground,
              labelColor: AmpColors.colorForeground,
              tabs: <Widget>[
                new Tab(
                  icon: Icon(Icons.home),
                  text: 'Start',
                ),
                new Tab(
                  icon: Icon(Icons.settings),
                  text: 'Einstellungen',
                )
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        )
      ),
    );
  }
  List<String> classes = ['5','6','7','8','9','10','11','12','13',];
  String currentSelectedDropdownClassValue = '5';
  String currentSelectedDropdownCharValue = 'A';
}

class Klasse extends StatelessWidget {
  Widget displayWidget;
  Klasse(this.displayWidget);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
          child: displayWidget,
      )
    );
  }

}
