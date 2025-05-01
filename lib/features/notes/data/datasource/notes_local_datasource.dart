import 'package:app_notes/features/notes/data/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class NotesLocalDatasource {
  final Database db;

  NotesLocalDatasource(this.db);

  Future<List<NoteModel>> getAllNotes() async {
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return maps.map((note) => NoteModel.fromMap(note)).toList();
  }

  Future<void> addNote(NoteModel noteModel) async {
    await db.insert('notes', noteModel.toMap());
  }

  Future<void> updateNote(NoteModel noteModel) async {
    await db.update(
      'notes',
      noteModel.toMap(),
      where: 'idNote = ?',
      whereArgs: [noteModel.idNote],
    );
  }

  Future<void> deleteNote(String idNote) async {
    await db.delete(
      'notes',
      where: 'idNote = ?',
      whereArgs: [idNote],
    );
  }
}
