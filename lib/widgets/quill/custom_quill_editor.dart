
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomQuillEditor extends StatelessWidget {
  const CustomQuillEditor({
    super.key,
    required QuillController controller,
    required FocusNode focusNode,
  }) : _controller = controller, _focusNode = focusNode;

  final QuillController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      focusNode: _focusNode,
      configurations: const QuillEditorConfigurations(
        placeholder: 'Escribe aquí...',
        expands: true,
        customStyles: DefaultStyles(
          placeHolder: DefaultTextBlockStyle(
              TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              HorizontalSpacing.zero,
              VerticalSpacing.zero,
              VerticalSpacing.zero,
              BoxDecoration()),
        ),
      ),
    );
  }
}