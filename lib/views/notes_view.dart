import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/theme/colors.dart';
import 'package:mynotes/views/add_note_view.dart';
import 'package:mynotes/views/list_notes_view.dart';
import 'package:mynotes/views/update_profile_view.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/languages.dart' as langs;
import '../auth/auth_firebase.dart';

// ignore_for_file: constant_identifier_names
enum MenuAction { LOGOUT, CHANGE_THEME, UPDATE_PROFILE }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  int themeColor = colors['red']?['l'] as int;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    var email = currentUser?.email?.split('@')[0] ?? '';

    return Scaffold(
      backgroundColor: Color(themeColor),
      appBar: AppBar(
          title: Text(
            FlutterI18n.translate(context, langs.appTitle),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: [
            Center(
                child: Text(
              '${FlutterI18n.translate(context, langs.hello)} $email',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            )),
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              devtools.log('Selected $value.toString()');

              switch (value) {
                case MenuAction.LOGOUT:
                  final shouldLogout = await showLogoutDialog(context);

                  if (shouldLogout) {
                    FirebaseAuth.instance.signOut();

                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }

                  break;

                case MenuAction.CHANGE_THEME:
                  // list colors of the app's theme
                  const themes = [
                    'red',
                    'pink',
                    'purple',
                    'deepPurple',
                    'indigo',
                    'blue',
                    'lightBlue',
                    'cyan',
                    'teal',
                    'green',
                    'lightGreen',
                    'lime',
                    'yellow',
                    'amber',
                    'orange',
                    'deepOrange',
                    'brown',
                    'blueGray'
                  ];
                  const bg = ['l', 'b'];
                  final random = Random();
                  setState(() {
                    themeColor = colors[themes[random.nextInt(18)]]
                        ?[bg[random.nextInt(2)]] as int;
                  });
                  break;

                case MenuAction.UPDATE_PROFILE:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateProfileView(
                                user: currentUser,
                              )));
                  break;

                default:
                  devtools.log('Unknown value: $value');
              }
            }, itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.UPDATE_PROFILE,
                  child: Text(
                      FlutterI18n.translate(context, langs.menuItemProfile)),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.CHANGE_THEME,
                  child:
                      Text(FlutterI18n.translate(context, langs.menuItemTheme)),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.LOGOUT,
                  child: Text(
                      FlutterI18n.translate(context, langs.menuItemLogout)),
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
                      fit: BoxFit.cover,
                      opacity: 0.5)),
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
              title:
                  Text(FlutterI18n.translate(context, langs.logoutDialogTitle)),
              content: Text(
                  FlutterI18n.translate(context, langs.logoutDialogContent)),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text((FlutterI18n.translate(
                        context, langs.logoutDialogCancelButton)))),
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
                    child: Text(FlutterI18n.translate(
                        context, langs.logoutDialogLogoutButton))),
              ])).then((value) => value ?? false);
}
