import 'package:app_notes/core/theme/dimensions.dart';
import 'package:app_notes/features/notes/domain/entity/note_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardNote extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isSelectionMode;
  final Function() onLongPress;
  const CardNote({
    super.key,
    required this.note,
    required this.onTap,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Hero(
        tag: 'note_${note.idNote}',
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.defaultPadding),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Dimensions.defaultPadding),
                    Text(
                      note.content,
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: Dimensions.defaultPadding),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _formatDate(note.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isSelectionMode)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: isSelected ? Colors.white : Colors.transparent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeFormat = DateFormat('h:mm a', 'es');
    final time = timeFormat.format(dateTime);

    if (dateToCompare == today) {
      return 'Hoy, $time'.toUpperCase();
    } else if (dateToCompare == yesterday) {
      return 'Ayer, $time'.toUpperCase();
    } else {
      // Para fechas del año actual, mostrar día y mes
      if (dateTime.year == now.year) {
        return DateFormat('d MMM', 'es').format(dateTime);
      }
      // Para años diferentes, mostrar fecha completa
      else {
        return DateFormat('d MMM y', 'es').format(dateTime);
      }
    }
  }
}
