class NoteEntity {
  final String idNote;
  final String title;
  final String content;
  final String quillDelta;
  final DateTime createdAt;

  NoteEntity({
    required this.idNote,
    required this.title,
    required this.content,
    required this.quillDelta,
    required this.createdAt,
  });
}
