abstract class NotesEvent {}

class GetAllNotesEvent extends NotesEvent {
  final bool? showLoading;

  GetAllNotesEvent({this.showLoading});
}

class AddNoteEvent extends NotesEvent {
  final String title;
  final String content;
  final String quillDelta;

  AddNoteEvent({
    required this.title,
    required this.content,
    required this.quillDelta,
  });
}

class UpdateNoteEvent extends NotesEvent {
  final String idNote;
  final String title;
  final String content;
  final String quillDelta;

  UpdateNoteEvent({
    required this.idNote,
    required this.title,
    required this.content,
    required this.quillDelta,
  });
}

class DeleteNoteEvent extends NotesEvent {
  final String idNote;
  DeleteNoteEvent({required this.idNote});
}

class DeleteMultipleNotesEvent extends NotesEvent {
  final List<String> ids;

  DeleteMultipleNotesEvent({required this.ids});
}

class SelectNoteEvent extends NotesEvent {
  final String noteId;
  SelectNoteEvent(this.noteId);
}

class ToggleSelectionEvent extends NotesEvent {
  final String noteId;
  ToggleSelectionEvent(this.noteId);
}

class ClearSelectionEvent extends NotesEvent {}

class SelectAllNotesEvent extends NotesEvent {
  final List<String> noteIds;

  SelectAllNotesEvent(this.noteIds);
}
