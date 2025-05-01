import 'package:app_notes/features/notes/domain/entity/note_entity.dart';
import 'package:app_notes/features/notes/domain/usecases/add_note_use_case.dart';
import 'package:app_notes/features/notes/domain/usecases/delete_note_use_case.dart';
import 'package:app_notes/features/notes/domain/usecases/get_all_notes_use_case.dart';
import 'package:app_notes/features/notes/domain/usecases/update_note_use_case.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_events.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetAllNotesUseCase getAllNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  NotesBloc({
    required this.getAllNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  }) : super(const NotesState()) {
    on<GetAllNotesEvent>(_onGetAllNotesEvent);
    on<AddNoteEvent>(_onAddNoteEvent);
    on<UpdateNoteEvent>(_onUpdateNoteEvent);
    on<DeleteNoteEvent>(_onDeleteNoteEvent);
    on<SelectNoteEvent>(_onSelectNoteEvent);
    on<ToggleSelectionEvent>(_onToggleSelectionEvent);
    on<ClearSelectionEvent>(_onClearSelectionEvent);
    on<DeleteMultipleNotesEvent>(_onDeleteMultipleNotesEvent);
    on<SelectAllNotesEvent>(_onSelectAllNotesEvent);
  }

  Future<void> _onGetAllNotesEvent(GetAllNotesEvent event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.loading));

    try {
      final notes = await getAllNotesUseCase();
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(state.copyWith(status: NotesStatus.success, notes: notes));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: 'Error al cargar notas',
      ));
    }
  }

  Future<void> _onAddNoteEvent(AddNoteEvent event, Emitter<NotesState> emit) async {
    try {
      final newNote = await addNoteUseCase(event.title, event.content, event.quillDelta);

      // Actualizar el estado con la nueva nota sin recargar todas
      final updatedNotes = List<NoteEntity>.from(state.notes)..add(newNote);

      updatedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      emit(state.copyWith(
        status: NotesStatus.success,
        notes: updatedNotes,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: 'Error al agregar nota',
      ));
    }
  }

  Future<void> _onUpdateNoteEvent(UpdateNoteEvent event, Emitter<NotesState> emit) async {
    try {
      final updatedNote =
          await updateNoteUseCase(event.idNote, event.title, event.content, event.quillDelta);

      // Actualizar el estado con la nota modificada sin recargar todas
      final updatedNotes = state.notes.map((note) {
        return note.idNote == event.idNote ? updatedNote : note;
      }).toList();

       updatedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(state.copyWith(
        status: NotesStatus.success,
        notes: updatedNotes,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: 'Error al actualizar nota',
      ));
    }
  }

  Future<void> _onDeleteNoteEvent(DeleteNoteEvent event, Emitter<NotesState> emit) async {
    try {
      final updatedNotes = List<NoteEntity>.from(state.notes)
          .where(
            (note) => note.idNote != event.idNote,
          )
          .toList();

      emit(state.copyWith(notes: updatedNotes));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: 'Error al eliminar nota',
      ));
    }
  }

  Future<void> _onSelectNoteEvent(SelectNoteEvent event, Emitter<NotesState> emit) async {
    final updated = Set<String>.from(state.selectedNoteIds)..add(event.noteId);
    emit(state.copyWith(
      selectedNoteIds: updated,
      isSelectionMode: true,
    ));
  }

  Future<void> _onToggleSelectionEvent(ToggleSelectionEvent event, Emitter<NotesState> emit) async {
    final updated = Set<String>.from(state.selectedNoteIds);
    if (updated.contains(event.noteId)) {
      updated.remove(event.noteId);
    } else {
      updated.add(event.noteId);
    }

    emit(state.copyWith(
      selectedNoteIds: updated,
      isSelectionMode: updated.isNotEmpty,
    ));
  }

  Future<void> _onClearSelectionEvent(ClearSelectionEvent event, Emitter<NotesState> emit) async {
    emit(state.copyWith(
      selectedNoteIds: const {},
      isSelectionMode: false,
    ));
  }

  Future<void> _onDeleteMultipleNotesEvent(
      DeleteMultipleNotesEvent event, Emitter<NotesState> emit) async {
    try {
      final updatedNotes = state.notes.where((note) => !event.ids.contains(note.idNote)).toList();

      emit(state.copyWith(
        notes: updatedNotes,
        selectedNoteIds: <String>{},
        isSelectionMode: false,
      ));

      for (var id in event.ids) {
        await deleteNoteUseCase(id);
      }
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.error,
        errorMessage: 'Error al eliminar notas',
      ));
    }
  }

  Future<void> _onSelectAllNotesEvent(SelectAllNotesEvent event, Emitter<NotesState> emit) async {
    emit(state.copyWith(
      selectedNoteIds: Set<String>.from(event.noteIds),
      isSelectionMode: event.noteIds.isNotEmpty,
    ));
  }
}
