import 'package:app_notes/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomQuillEditor extends StatelessWidget {
  const CustomQuillEditor({
    super.key,
    required QuillController controller,
    required FocusNode focusNode,
  })  : _controller = controller,
        _focusNode = focusNode;

  final QuillController _controller;
  final FocusNode _focusNode;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      focusNode: _focusNode,
      config:  QuillEditorConfig(
        placeholder: 'Escribe aquí...',
        expands: true,
        onLaunchUrl: _launchUrl,
        customStyles: const DefaultStyles(
          placeHolder: DefaultTextBlockStyle(
            TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            HorizontalSpacing.zero,
            VerticalSpacing.zero,
            VerticalSpacing.zero,
            BoxDecoration(),
          ),
          link: TextStyle(
            color: AppColors.primaryDark,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primaryLight,
            decorationStyle: TextDecorationStyle.solid,
          ),
        ),
      ),
    );
  }
}
