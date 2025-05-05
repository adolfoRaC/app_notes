import 'package:app_notes/features/notes/data/datasource/notes_local_datasource.dart';
import 'package:app_notes/features/notes/data/models/note_model.dart';
import 'package:app_notes/features/notes/domain/entity/note_entity.dart';
import 'package:app_notes/features/notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NotesLocalDatasource datasource;

  NoteRepositoryImpl({required this.datasource});

  @override
  Future<List<NoteEntity>> getAllNotes() {
    return datasource.getAllNotes();
  }

  @override
  Future<void> addNote(NoteEntity noteEntity) async {
    return datasource.addNote(
      NoteModel(
        idNote: noteEntity.idNote,
        title: noteEntity.title,
        content: noteEntity.content,
        quillDelta: noteEntity.quillDelta,
        createdAt: noteEntity.createdAt,
      ),
    );
  }

  @override
  Future<void> updateNote(NoteEntity noteEntity) {
    return datasource.updateNote(
      NoteModel(
        idNote: noteEntity.idNote,
        title: noteEntity.title,
        content: noteEntity.content,
        quillDelta: noteEntity.quillDelta,
        createdAt: noteEntity.createdAt,
      ),
    );
  }

  @override
  Future<void> deleteNote(String idNote) {
    return datasource.deleteNote(idNote);
  }
}
