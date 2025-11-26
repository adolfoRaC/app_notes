import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomQuillSimpleToolbar extends StatelessWidget {
  const CustomQuillSimpleToolbar({
    super.key,
    required QuillController controller,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return QuillSimpleToolbar(
      controller: _controller,
      config: const QuillSimpleToolbarConfig(
        axis: Axis.horizontal,
        showDirection: true,
        multiRowsDisplay: false,
        showUndo: false,
        showRedo: false,
        showSearchButton: false,
        showClipboardCopy: false,
        showClipboardCut: false,
        showClipboardPaste: false,
      ),
    );
  }
}