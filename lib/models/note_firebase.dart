import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_flutter/models/note.dart';
import 'dart:developer';

class NoteFirebase {
  // get database instance
  final db = FirebaseFirestore.instance;

  /// get all notes in database
  Future<List<Map<String, dynamic>>> list() async {
    log('Get all notes in database...');
    return db
        .collection('notes')
        .orderBy('title', descending: false)
        .limit(20)
        .get()
        .then((event) {
      List<Map<String, dynamic>> list = [];
      for (final doc in event.docs) {
        final obj = doc.data();
        final note = Map<String, dynamic>.from(obj);
        note['id'] = doc.id;
        list.add(note);
      }
      return list;
    });
  }

  /// get a note in database by id
  Future<Map<String, dynamic>> getNote(String id) async {
    log('Get note by id...');
    return db
        .collection('notes')
        .doc(id)
        .get()
        .then((value) => value as Map<String, dynamic>);
  }

  /// insert a note into database
  Future<Note> insert(Note note) async {
    log('insert a note into database...');
    final docRef = await db.collection('notes').add(note.toMap());
    final docId = docRef.id;
    return Note(id: docId, title: note.title, content: note.content);
  }

  /// update a note by id
  Future<bool> update(Note note) async {
    log('update a note in database by id');
    return await db
        .collection('notes')
        .doc(note.id)
        .update(note.toMap())
        .then((_) => true);
  }

  /// delete a note in database
  Future<bool> delete(String id) async {
    log('delete a note into database by id...');
    return db.collection('notes').doc(id).delete().then((_) => true);
  }
}
