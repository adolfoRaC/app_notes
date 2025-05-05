import 'dart:convert';
import 'package:app_notes/core/controller/data_controller.dart';
import 'package:app_notes/core/theme/dimensions.dart';
import 'package:app_notes/features/notes/domain/entity/note_entity.dart';
import 'package:app_notes/widgets/buttons/save_note_button.dart';
import 'package:app_notes/widgets/quill/custom_quill_editor.dart';
import 'package:app_notes/widgets/quill/custom_quill_simple_toolbar.dart';
import 'package:app_notes/widgets/textField/tittle_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateNoteScreen extends StatefulWidget {
  const UpdateNoteScreen({super.key});

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  late TextEditingController _titleController;
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  final NoteEntity note = Get.find<DataController>().getData("note");

  String _initialTitle = "";
  String _initialContent = "";
  String _initialDelta = "";
  bool _contentChanged = false;

  int _characterCount = 0;

  List<dynamic> _decodeDelta(String quillDelta) {
    return jsonDecode(quillDelta) as List<dynamic>;
  }

  @override
  void initState() {
    super.initState();
    _initialTitle = note.title;
    _initialDelta = note.quillDelta;

    _titleController = TextEditingController(text: note.title);
    _controller = QuillController(
      document: Document.fromJson(_decodeDelta(note.quillDelta)),
      selection: const TextSelection.collapsed(offset: 0),
    );

    _initialContent = _controller.document.toPlainText();

    _updateCharacterCount();

    _titleController.addListener(() {
      _checkForChanges();
      setState(() {});
    });

    _controller.addListener(() {
      _checkForChanges();
      setState(() {});
    });
    _controller.addListener(
      _updateCharacterCount,
    );
  }

  void _updateCharacterCount() {
    final plainText = _controller.document.toPlainText();
    final textWithoutSpaces = plainText.replaceAll(' ', '').replaceAll('\n', '');
    setState(() {
      _characterCount = textWithoutSpaces.length;
    });
  }

  void _checkForChanges() {
    final currentContent = _controller.document.toPlainText();
    final currentDelta = jsonEncode(_controller.document.toDelta().toJson());
    final currentTitle = _titleController.text;

    setState(() {
      _contentChanged = currentTitle != _initialTitle ||
          currentContent != _initialContent ||
          currentDelta != _initialDelta;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCharacterCount);
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Actualizar nota',
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
            isUpdate: true,
            idNote: note.idNote,
            contentChanged: _contentChanged,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.defaultPadding),
          child: Column(
            children: [
              TittleTextField(titleController: _titleController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat("dd 'de' MMMM 'del' yyyy h:mm a", 'es_Es').format(DateTime.now()),
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
        ),
      ),
    );
  }
}
