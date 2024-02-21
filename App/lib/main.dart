import 'package:ethos_app/Screens/Login.dart';
import 'package:ethos_app/Screens/Splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Screens/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ethos App',
      locale: const Locale('it', 'IT'),
      supportedLocales: const [
        Locale('it', 'IT'),
      ],
      home: const SplashScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(163, 0, 6, 1),
        primarySwatch: Colors.red,
        // Define the default brightness and colors.
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      routes: {
        'home': (context) => HomePage(),
        'login': (context) => const LoginScreen(),
      },
    );
  }
}
