import 'package:app_notes/features/notes/domain/entity/note_entity.dart';

enum NotesStatus { initial, loading, success, error }

class NotesState {
  final NotesStatus status;
  final List<NoteEntity> notes;
  final String? errorMessage;
  final Set<String> selectedNoteIds;
  final bool isSelectionMode;

  const NotesState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.errorMessage,
    this.selectedNoteIds = const {},
    this.isSelectionMode = false,
  });

  NotesState copyWith({
    NotesStatus? status,
    List<NoteEntity>? notes,
    String? errorMessage,
    Set<String>? selectedNoteIds,
    bool? isSelectionMode,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedNoteIds: selectedNoteIds ?? this.selectedNoteIds,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
    );
  }
}
