import 'package:flutter/material.dart';

class TittleTextField extends StatelessWidget {
  const TittleTextField({
    super.key,
    required TextEditingController titleController,
  }) : _titleController = titleController;

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        hintText: 'Título',
        alignLabelWithHint: true,
        hintStyle: TextStyle(fontSize: 16),
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
    );
  }
}