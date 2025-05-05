import 'dart:convert';

import 'package:app_notes/core/theme/dimensions.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:app_notes/features/notes/presentation/bloc/notes_state.dart';
import 'package:app_notes/widgets/buttons/save_note_button.dart';
import 'package:app_notes/widgets/quill/custom_quill_editor.dart';
import 'package:app_notes/widgets/quill/custom_quill_simple_toolbar.dart';
import 'package:app_notes/widgets/textField/tittle_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:intl/intl.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  int _characterCount = 0;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));

    _controller.addListener(_onDocumentChange);
  }

  void _onDocumentChange() {
    final plainText = _controller.document.toPlainText();
    final textWithoutSpaces = plainText.replaceAll(' ', '').replaceAll('\n', '');
    final newCount = textWithoutSpaces.length;

    final delta = _controller.document.toDelta();
    final deltaJson = jsonEncode(delta.toJson());

    // Un documento vacío en QuillEditor tiene un delta específico
    // Generalmente algo como [{"insert":"\n"}]
    // Comprobamos si hay más que solo un salto de línea
    final bool hasMarkdownOrContent = deltaJson != '[{"insert":"\\n"}]' && deltaJson.length > 15;

    setState(() {
      _characterCount = newCount;
      _hasContent = hasMarkdownOrContent || plainText.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onDocumentChange);
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Agregar nota',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          QuillToolbarHistoryButton(
            controller: _controller,
            isUndo: true,
          ),
          QuillToolbarHistoryButton(
            controller: _controller,
            isUndo: false,
          ),
          SaveNoteButton(
            controller: _controller,
            titleController: _titleController,
            hasContent: _hasContent,
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.defaultPadding),
              child: Column(
                children: [
                  TittleTextField(titleController: _titleController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("dd 'de' MMMM 'del' yyyy h:mm a", 'es_Es')
                            .format(DateTime.now()),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        '$_characterCount Caracteres',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.defaultPadding),
                  CustomQuillSimpleToolbar(controller: _controller),
                  Expanded(
                    child: CustomQuillEditor(controller: _controller, focusNode: _focusNode),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
