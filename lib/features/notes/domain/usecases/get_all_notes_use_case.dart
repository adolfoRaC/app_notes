import 'package:app_notes/features/notes/domain/entity/note_entity.dart';
import 'package:app_notes/features/notes/domain/repositories/note_repository.dart';

class GetAllNotesUseCase{
  final NoteRepository noteRepository;

  GetAllNotesUseCase({required this.noteRepository});

  Future<List<NoteEntity>> call() async {
    return await noteRepository.getAllNotes();
  }
}