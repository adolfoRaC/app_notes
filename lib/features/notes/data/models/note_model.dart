import 'package:app_notes/features/notes/domain/entity/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    required super.idNote,
    required super.title,
    required super.content,
    required super.quillDelta,
    required super.createdAt,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      idNote: map['idNote'],
      title: map['title'],
      content: map['content'],
      quillDelta: map['quillDelta'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idNote': idNote,
      'title': title,
      'content': content,
      'quillDelta': quillDelta,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
