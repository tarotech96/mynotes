import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mynotes/models/note_entity.dart';
import 'package:mynotes/services/note_firebase.dart';
import 'package:mynotes/constants/languages.dart' as langs;
import 'dart:developer' as devtools show log;

import 'package:mynotes/views/notes_view.dart';

const c0 = 0xff123456,
    c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A,
    c8 = 0x3300B1CC,
    c9 = 0xCCFF595E;

class AddNoteView extends StatefulWidget {
  const AddNoteView({Key? key}) : super(key: key);

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(
        Icons.add,
        color: Color(c5),
      ),
      tooltip: 'ノート追加',
      backgroundColor: const Color(c4),
      onPressed: () async => await showDialogAddNote(context),
    );
  }
}

/// show dialog to add a new note
Future<bool> showDialogAddNote(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title = TextEditingController();
  late final TextEditingController _content = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title:
                Text(FlutterI18n.translate(context, langs.dialogAddNoteTitle)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Form(
              key: _formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(
                          labelText: FlutterI18n.translate(
                              context, langs.dialogAddNoteInputTitle),
                          hintText: FlutterI18n.translate(
                              context, langs.dialogAddNoteInputTitleHintText)),
                      validator: (value) {
                        if (value == null) {
                          return "Please enter title";
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   print(value);
                      // },
                    ),
                    TextFormField(
                      controller: _content,
                      decoration: InputDecoration(
                          labelText: FlutterI18n.translate(
                              context, langs.dialogAddNoteInputContent),
                          hintText: FlutterI18n.translate(context,
                              langs.dialogAddNoteInputContentHintText)),
                      maxLines: 9,
                      validator: (value) {
                        if (value == null) {
                          return "Please enter content";
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   print(value);
                      // },
                    )
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(FlutterI18n.translate(
                    context, langs.dialogAddNoteCancelButton)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red, onPrimary: Colors.white),
              ),
              ElevatedButton(
                onPressed: () async {
                  final noteFirebase = NoteFirebase();
                  var note = NoteEntity(
                    title: _title.text,
                    content: _content.text,
                  );
                  try {
                    final res = await noteFirebase.insert(note);
                    if (res.title.isNotEmpty && res.content.isNotEmpty) {
                      devtools.log('Inserted successful...');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotesView()),
                          (_) => false);
                    }
                  } catch (e) {
                    devtools.log('Something went wrong...');
                  }
                },
                child: Text(FlutterI18n.translate(
                    context, langs.dialogAddNoteSaveButton)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue, onPrimary: Colors.white),
              )
            ],
          )).then((value) => value ?? false);
}
