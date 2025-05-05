
import 'package:app_notes/features/notes/domain/repositories/note_repository.dart';

class DeleteNoteUseCase{
  final NoteRepository notesRepository;

  DeleteNoteUseCase({required this.notesRepository});

  Future<void> call(String idNote) async {
    await notesRepository.deleteNote(idNote);
  }
}
