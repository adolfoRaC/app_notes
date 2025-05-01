import 'package:app_notes/features/notes/domain/entity/note_entity.dart';

abstract class NoteRepository {
  Future<List<NoteEntity>> getAllNotes();
  Future<void> addNote(NoteEntity noteEntity);
  Future<void> updateNote(NoteEntity noteEntity);
  Future<void> deleteNote(String idNote);
}
