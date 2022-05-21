import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/edit_note_view.dart';
import '../services/note_firebase.dart';
import 'notes_view.dart';
import 'dart:developer';

class RenderNotesList extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  // ignore: use_key_in_widget_constructors
  const RenderNotesList(this.data);

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Material(
              elevation: 1,
              color: const Color.fromARGB(200, 4, 68, 230),
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(5.0),
              child: InkWell(
                  onTap: () {
                    log('Tapped here...');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditNoteView(
                                  noteItem: item,
                                )));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Row(
                      children: [
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
                                    color: Color.fromARGB(255, 252, 255, 255),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 3,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  item['content'],
                                  maxLines: 20,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 252, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
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
                                        color:
                                            Color.fromARGB(255, 106, 126, 193),
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
