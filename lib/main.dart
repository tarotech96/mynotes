import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:learn_flutter/constants/routes.dart';
import 'package:learn_flutter/firebase_options.dart';
import 'package:learn_flutter/views/edit_note_view.dart';
import 'package:learn_flutter/views/login_view.dart';
import 'package:learn_flutter/views/notes_view.dart';
import 'package:learn_flutter/views/register_view.dart';

void main() async {
  // Create a instance of the WidgetsBinding
  // If want to use Flutter Engine so this setting is neccessary before call runApp() method
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
      home: const LoginScreen(),
      // theme: ThemeData(fontFamily: 'Montserrat', primarySwatch: Colors.purple),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        updateNote: (context) => const EditNoteView()
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
                Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 255, 255, 254),
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
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
            return const Text('Not found app...');
        }
      },
    );
  }
}
