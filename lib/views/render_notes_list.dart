import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/views/edit_note_view.dart';
import '../models/note_firebase.dart';
import 'notes_view.dart';
import 'dart:developer';

class RenderNotesList extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  // ignore: use_key_in_widget_constructors
  const RenderNotesList(this.data);

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      isAlwaysShown: false,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
            child: Material(
              elevation: 1,
              color: const Color.fromARGB(202, 147, 220, 230),
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(5.0),
              child: InkWell(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(204, 237, 233, 234),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditNoteView(noteItem: item)));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 106, 132, 225),
                                    size: 21,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            item['title'],
                            style: const TextStyle(
                                color: Color(c3),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 3,
                          ),
                          Text(
                            item['content'],
                            maxLines: 20,
                            style: const TextStyle(
                                color: Color(c7),
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(204, 237, 233, 234),
                                shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: IconButton(
                                  onPressed: () async {
                                    final noteFirebase = NoteFirebase();

                                    try {
                                      await noteFirebase.delete(item['id']);
                                      log('Deleted successful...');
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotesView()),
                                          (_) => false);
                                    } catch (e) {
                                      log('Something went wrong...');
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 106, 126, 193),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}
