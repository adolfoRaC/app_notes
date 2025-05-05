import 'package:app_notes/features/notes/domain/entity/note_entity.dart';
import 'package:app_notes/features/notes/domain/repositories/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository noteRepository;

  UpdateNoteUseCase({required this.noteRepository});

  Future<NoteEntity> call(String idNote, String title, String content, String quillDelta) async {
    final updatedNote = NoteEntity(
      idNote: idNote,
      title: title,
      content: content,
      quillDelta: quillDelta,
      createdAt: DateTime.now(),
    );

    await noteRepository.updateNote(updatedNote);
    return updatedNote;
  }
}
