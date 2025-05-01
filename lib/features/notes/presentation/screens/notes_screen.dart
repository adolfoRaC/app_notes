import 'package:app_notes/core/config/route_names.dart';
import 'package:app_notes/core/controller/data_controller.dart';
import 'package:app_notes/core/theme/dimensions.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_events.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_state.dart';
import 'package:app_notes/widgets/cards/card_note.dart';
import 'package:app_notes/widgets/buttons/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with TickerProviderStateMixin {
  // Controller para animaciones de eliminación
  late AnimationController _deleteAnimationController;
  final Map<String, Animation<double>> _deleteAnimations = {};
  final Map<String, bool> _notesBeingDeleted = {};

  @override
  void initState() {
    super.initState();
    _deleteAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Cargar notas cuando se abre la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesBloc>().add(GetAllNotesEvent());
    });
  }

  @override
  void dispose() {
    _deleteAnimationController.dispose();
    super.dispose();
  }

  // Método para cancelar el modo de selección
  void _cancelSelectionMode() {
    context.read<NotesBloc>().add(ClearSelectionEvent());
  }

  // Método para eliminar notas seleccionadas con animación
  Future<void> _deleteSelectedNotes(List<String> noteIds) async {
    // Preparar animaciones para cada nota a eliminar
    for (var id in noteIds) {
      _notesBeingDeleted[id] = true;
      final Animation<double> animation = Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: _deleteAnimationController,
          curve: Curves.easeOut,
        ),
      );
      _deleteAnimations[id] = animation;
    }

    // Iniciar animación y esperar a que termine
    _deleteAnimationController.forward(from: 0.0).then((_) {
      // Eliminar notas después de la animación
      context.read<NotesBloc>().add(DeleteMultipleNotesEvent(ids: noteIds));
      // Limpiar datos de animación
      _deleteAnimations.clear();
      _notesBeingDeleted.clear();
      _deleteAnimationController.reset();
    });
  }

  Widget _buildLoadingOrError(NotesState state) {
    if (state.status == NotesStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.status == NotesStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Error al cargar las notas',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<NotesBloc>().add(GetAllNotesEvent()),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Estado desconocido',
          style: TextStyle(fontSize: 14),
        ),
      );
    }
  }

  Widget _buildEmptyNotesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay notas disponibles',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crea una nueva nota con el botón +',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Interceptar el botón de retroceso para cancelar el modo selección
      onPopInvoked: (bool _) async {
        final state = context.read<NotesBloc>().state;
        if (state.isSelectionMode) {
          _cancelSelectionMode();
        }
      },
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state.isSelectionMode ? '${state.selectedNoteIds.length} seleccionadas' : 'Mis notas',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: state.isSelectionMode ? 18 : 20,
                ),
              ),
              leading: state.isSelectionMode
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _cancelSelectionMode,
                    )
                  : null,
              actions: [
                if (state.isSelectionMode) ...[
                  // Mostrar contador de selección
                  IconButton(
                    icon: const Icon(Icons.select_all),
                    tooltip: 'Seleccionar todo',
                    onPressed: () {
                      final allIds = state.notes.map((note) => note.idNote).toList();
                      // Implementar "Seleccionar todo" en el bloc
                      for (var id in allIds) {
                        if (!state.selectedNoteIds.contains(id)) {
                          context.read<NotesBloc>().add(SelectNoteEvent(id));
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Eliminar seleccionados',
                    onPressed: () {
                      if (state.selectedNoteIds.isNotEmpty) {
                        // Mostrar diálogo de confirmación
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Eliminar notas'),
                            content: Text('¿Estás seguro de eliminar ${state.selectedNoteIds.length} '
                                '${state.selectedNoteIds.length == 1 ? 'nota' : 'notas'}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _deleteSelectedNotes(state.selectedNoteIds.toList());
                                },
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ] else ...[
                  const DarkMode(),
                ],
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.defaultPadding),
                child: state.status == NotesStatus.success
                    ? state.notes.isNotEmpty
                        ? _buildNotesGrid(state)
                        : _buildEmptyNotesView()
                    : _buildLoadingOrError(state),
              ),
            ),
            floatingActionButton: state.isSelectionMode
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      Get.toNamed(RouteNames.addNoteScreen);
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildNotesGrid(NotesState state) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: state.notes.length,
      itemBuilder: (context, index) {
        final note = state.notes[index];
        final isSelected = state.selectedNoteIds.contains(note.idNote);
        final isBeingDeleted = _notesBeingDeleted[note.idNote] ?? false;

        // Si la nota está siendo eliminada, aplicar la animación de escala y opacidad
        if (isBeingDeleted) {
          return AnimatedBuilder(
            animation: _deleteAnimations[note.idNote]!,
            builder: (context, child) {
              return Opacity(
                opacity: _deleteAnimations[note.idNote]!.value,
                child: Transform.scale(
                  scale: _deleteAnimations[note.idNote]!.value,
                  child: child,
                ),
              );
            },
            child: CardNote(
              isSelected: isSelected,
              isSelectionMode: state.isSelectionMode,
              note: note,
              onLongPress: () {},
              onTap: () {},
            ),
          );
        }

        // Si no está siendo eliminada, mostrar normalmente
        return CardNote(
          isSelected: isSelected,
          isSelectionMode: state.isSelectionMode,
          note: note,
          onLongPress: () {
            context.read<NotesBloc>().add(SelectNoteEvent(note.idNote));
          },
          onTap: () {
            if (state.isSelectionMode) {
              context.read<NotesBloc>().add(ToggleSelectionEvent(note.idNote));
            } else {
              Get.find<DataController>().setData("note", note);
              Get.toNamed(RouteNames.updateNoteScreen);
            }
          },
        );
      },
    );
  }
}
