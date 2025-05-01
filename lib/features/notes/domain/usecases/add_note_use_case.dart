import 'package:app_notes/features/notes/domain/entity/note_entity.dart';
import 'package:app_notes/features/notes/domain/repositories/note_repository.dart';
import 'package:uuid/uuid.dart';

class AddNoteUseCase{
  final NoteRepository notesRepository;

  AddNoteUseCase({required this.notesRepository});

   Future<NoteEntity> call(String title, String content, String quillDelta) async {
    final newNote = NoteEntity(
      idNote: const Uuid().v4(),
      title: title,
      content: content,
      quillDelta: quillDelta,
      createdAt: DateTime.now(),
    );
    await notesRepository.addNote(newNote);
    return newNote;
  }
}