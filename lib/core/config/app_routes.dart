import 'package:app_notes/core/config/route_names.dart';
import 'package:app_notes/features/notes/presentation/screens/add_note_screen.dart';
import 'package:app_notes/features/notes/presentation/screens/notes_screen.dart';
import 'package:app_notes/features/notes/presentation/screens/update_note_screen.dart';
import 'package:get/get.dart';

class AppRoutes{
   static final List<GetPage> routes = [
    GetPage(
      name: RouteNames.notesScreen,
      page: () => const NotesScreen(),
    ),
    GetPage(
      name: RouteNames.addNoteScreen,
      page: () => const AddNoteScreen(),
    ),
    GetPage(
      name: RouteNames.updateNoteScreen,
      page: () => const UpdateNoteScreen(),
    ),

  ];
}