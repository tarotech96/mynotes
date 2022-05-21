import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/loading_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/constants/languages.dart' as langs;

void main() async {
  // Create a instance of the WidgetsBinding
  // If want to use Flutter Engine so this setting is necessary before call runApp() method
  WidgetsFlutterBinding.ensureInitialized();

  // Read environment variables
  await DotEnv.dotenv.load(fileName: '.env.dev');

  // Run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(),
            missingTranslationHandler: (key, locale) {
              log(locale?.languageCode ?? '');
              log('--Missing Key: $key languageCode: ${locale?.languageCode}');
            }),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale(langs.langsCode['en'] ?? '', ''),
        Locale(langs.langsCode['ja'] ?? '', ''),
        Locale(langs.langsCode['vn'] ?? '', '')
      ],
      home: const LoginScreen(),
      // theme: ThemeData(fontFamily: 'Montserrat', primarySwatch: Colors.purple),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView()
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Stack(
              children: const [
                LoadingView(
                  width: 30,
                  height: 30,
                  strokeWidth: 2.0,
                ),
                Center(
                  child: DefaultTextStyle(
                    child: Text('No firebase apps connected...'),
                    style: TextStyle(
                        color: Color.fromARGB(255, 236, 171, 171),
                        fontSize: 20),
                  ),
                )
              ],
            );
          case ConnectionState.done:
            final currentUser = FirebaseAuth.instance.currentUser;

            if (currentUser != null) {
              return const NotesView();
            } else {
              return const LoginView();
            }
          default:
            return const LoadingView(
              width: 50,
              height: 50,
              strokeWidth: 3.0,
            );
        }
      },
    );
  }
}
