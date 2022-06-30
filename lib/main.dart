import 'package:bordered_text/bordered_text.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_config/flutter_config.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FREE To The Rescue!',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AnimatedSplashScreen(
              duration: 1000,
              backgroundColor: Colors.red.shade100,
              splash: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                    size: 100,
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  BorderedText(
                    strokeColor: Colors.red,
                    strokeWidth: 10.0,
                    child: Text(
                      "Free",
                      style: TextStyle(
                        letterSpacing: 10,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        decorationColor: Colors.white,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dotted,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ],
              ),
              centered: true,
              curve: Curves.bounceInOut,
              animationDuration: Duration(milliseconds: 1000),
              splashIconSize: 100,
              // splashIconSize: 1000,
              nextScreen: MyHomePage(
                title: 'FREE To The Rescue!',
              ),
              splashTransition: SplashTransition.slideTransition,
              pageTransitionType: PageTransitionType.bottomToTop,
            ),
      },
      theme: ThemeData(
        // primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
