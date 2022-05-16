import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/constants/routes.dart';
import 'package:learn_flutter/views/add_note_view.dart';
import 'dart:developer' as devtools show log;

import 'package:learn_flutter/views/list_notes_view.dart';

import '../auth/auth_firebase.dart';

enum MenuAction { logout, changeTheme }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  int themeColor = c6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(themeColor),
          title: const Text('Notes App'),
          actions: [
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              devtools.log('Selected $value.toString()');

              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);

                  if (shouldLogout) {
                    FirebaseAuth.instance.signOut();

                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }

                  break;

                case MenuAction.changeTheme:
                  // list colors of the app's theme
                  const colors = [c0, c1, c2, c3, c4, c5, c6, c7, c8, c9];
                  var random = Random();
                  setState(() {
                    themeColor = colors[random.nextInt(9)];
                  });
                  break;

                default:
                  devtools.log('Unknown value: $value');
              }
            }, itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.changeTheme,
                  child: Text('Change Theme'),
                ),
              ];
            })
          ]),
      body: Center(
          child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/originals/79/52/6c/79526c076a08e525becfd4215e1c6c16.jpg'),
                      fit: BoxFit.cover)),
              child: const ListNotesView())),
      floatingActionButton: const AddNoteView(),
    );
  }
}

/// show dialog
Future<bool> showLogoutDialog(BuildContext context) async {
  return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
              title: const Text('Sign out'),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(('Cancel'))),
                TextButton(
                    onPressed: () async {
                      final authentication = Authentication();
                      try {
                        await authentication.signOut(context: context);
                        Navigator.of(context).pop(true);
                      } on FirebaseAuthException catch (e) {
                        devtools.log(e.code);
                      } catch (e) {
                        devtools.log('Something went wrong...');
                        devtools.log(e.toString());
                      }
                    },
                    child: const Text('Sign out')),
              ])).then((value) => value ?? false);
}
