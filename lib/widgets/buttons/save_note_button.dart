import 'dart:convert';

import 'package:app_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_events.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class SaveNoteButton extends StatelessWidget {
  final QuillController controller;
  final TextEditingController titleController;
  final String? idNote;
  final bool? isUpdate;
  final bool? contentChanged;
  final bool? hasContent;

  const SaveNoteButton({
    super.key,
    required this.controller,
    required this.titleController,
    this.idNote,
    this.isUpdate = false,
    this.contentChanged,
    this.hasContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = context.select<NotesBloc, NotesStatus>((bloc) => bloc.state.status);

    bool hasChanged = true;
    bool contentHasValue = false;

    // Verificar si hay cambios en el modo de edición
    if (isUpdate == true && contentChanged != null) {
      hasChanged = contentChanged!;
    }

    // Verificar si hay contenido o formato
    if (hasContent != null) {
      contentHasValue = hasContent!;
    } else {
      // Si no se proporciona hasContent, verificar el texto directamente
      contentHasValue = controller.document.toPlainText().trim().isNotEmpty;
    }
    // Verificar que hay título y contenido, y que ha habido cambios si aplica
    final isEnabled = titleController.text.trim().isNotEmpty && contentHasValue && hasChanged;

    return IconButton(
      icon: Icon(
        Icons.save,
        color: isEnabled ? theme.colorScheme.primary : theme.disabledColor,
      ),
      onPressed: isEnabled
          ? () {
              final delta = controller.document.toDelta().toJson();
              final plainText = controller.document.toPlainText().trim();

              if (isUpdate == true) {
                context.read<NotesBloc>().add(
                      UpdateNoteEvent(
                        idNote: idNote!,
                        title: titleController.text,
                        content: plainText,
                        quillDelta: jsonEncode(delta),
                      ),
                    );
              } else {
                context.read<NotesBloc>().add(
                      AddNoteEvent(
                        title: titleController.text,
                        content: plainText,
                        quillDelta: jsonEncode(delta),
                      ),
                    );
              }

              if (status == NotesStatus.success) {
                titleController.clear();
                controller.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isUpdate! ? 'Nota actualizada' : 'Nota agregada'),
                  ),
                );
                // Get.offAllNamed(RouteNames.notesScreen);
                Get.back();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(isUpdate! ? 'Error al actualizar nota' : 'Error al agregar la nota'),
                  ),
                );
              }
            }
          : null,
    );
  }
}
