import 'package:app_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:app_notes/features/notes/data/datasource/notes_local_datasource.dart';
import 'package:app_notes/features/notes/data/repository/note_repository_impl.dart';
import 'package:app_notes/features/notes/domain/repositories/note_repository.dart';
import 'package:app_notes/features/notes/domain/usecases/add_note_use_case.dart';
import 'package:app_notes/features/notes/domain/usecases/delete_note_use_case.dart';
import 'package:app_notes/features/notes/domain/usecases/get_all_notes_use_case.dart';
import 'package:app_notes/features/notes/domain/usecases/update_note_use_case.dart';
import 'package:app_notes/features/theme/data/datasource/theme_local_datasource.dart';
import 'package:app_notes/features/theme/data/repository/theme_repository_impl.dart';
import 'package:app_notes/features/theme/domain/repository/theme_repository.dart';
import 'package:app_notes/features/theme/domain/usecases/get_theme_use_case.dart';
import 'package:app_notes/features/theme/domain/usecases/save_theme_use_case.dart';
import 'package:app_notes/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

Future init() async {
  // Theme
  getIt.registerSingleton(await SharedPreferences.getInstance());
  getIt.registerSingleton(ThemeLocalDatasource(sharedPreferences: getIt()));
  getIt.registerSingleton<ThemeRepository>(ThemeRepositoryImpl(themeLocalDatasource: getIt()));
  getIt.registerSingleton(GetThemeUseCase(themeRepository: getIt()));
  getIt.registerSingleton(SaveThemeUseCase(themeRepository: getIt()));
  getIt.registerFactory(() => ThemeBloc(getThemeUseCase: getIt(), saveThemeUseCase: getIt()));

  // Notes
  final String path = join(await getDatabasesPath(), 'my_notes.db');

  final Database db = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE notes(
          idNote TEXT PRIMARY KEY,
          title TEXT,
          content TEXT,
          quillDelta TEXT,
          createdAt TEXT
        )
      ''');
    },
  );

  getIt.registerSingleton<Database>(db);

  getIt.registerSingleton(NotesLocalDatasource(getIt()));
  getIt.registerSingleton<NoteRepository>(NoteRepositoryImpl(datasource: getIt()));
  getIt.registerSingleton(GetAllNotesUseCase(noteRepository: getIt()));
  getIt.registerSingleton(AddNoteUseCase(notesRepository: getIt()));
  getIt.registerSingleton(UpdateNoteUseCase(noteRepository: getIt()));
  getIt.registerSingleton(DeleteNoteUseCase(notesRepository: getIt()));


  getIt.registerFactory(
    () => NotesBloc(
      getAllNotesUseCase: getIt(),
      addNoteUseCase: getIt(),
      updateNoteUseCase: getIt(),
      deleteNoteUseCase: getIt(),
    ),
  );
}
