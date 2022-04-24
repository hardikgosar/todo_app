import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth/authscreen.dart';
import 'screens/home.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        future: _initialization,
        builder: (context, appsnapshot) {
          return MaterialApp(
            title: 'TODO',
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.red,
            ),
            debugShowCheckedModeBanner: false,
            home: appsnapshot.connectionState != ConnectionState.done
                ? const SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, usersnapshot) {
                      if (usersnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      }
                      if (usersnapshot.hasData) {
                        return const Home();
                      } else {
                        return AuthScreen();
                      }
                    }),
          );
        });
  }
}
