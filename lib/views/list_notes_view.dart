import 'package:flutter/material.dart';
import 'package:mynotes/services/note_firebase.dart';
import 'package:mynotes/views/edit_note_view.dart';
import 'package:mynotes/views/render_notes_list.dart';
import 'dart:developer';

class ListNotesView extends StatefulWidget {
  const ListNotesView({Key? key}) : super(key: key);

  @override
  State<ListNotesView> createState() => _ListNotesViewState();
}

class _ListNotesViewState extends State<ListNotesView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getListNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: <Widget>[
              RenderNotesList(snapshot.data as List<Map<String, dynamic>>),
            ],
          );
        } else if (snapshot.hasError) {
          log('Error getting list notes from database...');
          return const Text('');
        } else {
          return const Center(
            child: CircularProgressIndicator(backgroundColor: Color(c3)),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> getListNotes() async {
    try {
      final noteFirebase = NoteFirebase();
      return await noteFirebase.list();
    } catch (e) {
      log('Something went wrong...');
      log(e.toString());
      return [{}];
    }
  }
}
