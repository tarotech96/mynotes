import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/models/note_entity.dart';
import '../services/note_firebase.dart';
import 'package:mynotes/constants/languages.dart' as langs;
import 'dart:developer';
import 'notes_view.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A;

class EditNoteView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final noteItem;
  // ignore: use_key_in_widget_constructors
  const EditNoteView({this.noteItem});
  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  @override
  Widget build(BuildContext context) {
    final noteItem = widget.noteItem;
    late final TextEditingController _title =
        TextEditingController(text: noteItem['title']);
    late final TextEditingController _content =
        TextEditingController(text: noteItem['content']);
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, langs.editNoteTitle)),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.5,
                image: NetworkImage(
                    'https://images.pexels.com/photos/4207708/pexels-photo-4207708.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 300,
                height: 50,
                child: TextField(
                  controller: _title,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 63, 108, 53),
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  decoration:
                      const InputDecoration(border: UnderlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                height: 100,
                child: TextField(
                  controller: _content,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 63, 108, 53), fontSize: 16),
                  maxLines: 20,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (_) => false);
                  },
                  child: Text(
                    FlutterI18n.translate(context, langs.editNoteCancelButton),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange, onPrimary: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final noteFirebase = NoteFirebase();
                    final note = NoteEntity(
                        id: noteItem['id'],
                        title: _title.text,
                        content: _content.text);
                    try {
                      final res = await noteFirebase.update(note);
                      if (res) {
                        log('Updated successful...');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotesView()),
                            (_) => false);
                      }
                    } catch (e) {
                      log('Something went wrong...');
                    }
                  },
                  child: Text(
                    FlutterI18n.translate(context, langs.editNoteUpdateButton),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
