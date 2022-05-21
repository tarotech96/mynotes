class NoteEntity {
  // id of the note
  // ignore: prefer_typing_uninitialized_variables
  String? id;
  // title of the note
  String title;
  // content of the note
  String content;

  NoteEntity({this.id, required this.title, required this.content});

  factory NoteEntity.fromMap(Map<String, dynamic> json) =>
      NoteEntity(title: json['title'], content: json['content']);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    if (id != '') {
      data['id'] = id;
    }
    data['title'] = title;
    data['content'] = content;

    return data;
  }
}
