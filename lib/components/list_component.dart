import 'package:flutter/material.dart';

import '../database_helper/db_helper.dart';
import '../screens/add_edit_note.dart';

class MyListView extends StatelessWidget {
  final List<Map<String, dynamic>> notes;
  final Function() onDelete;
  final Function() onEdit;

  const MyListView(
      {super.key,
      required this.notes,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note['title']),
            subtitle: Text(note['description'] ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // delete note using widget.id
                showDialog(
                    context: context,
                    builder: ((context) => AlertDialog(
                          title: const Text('Delete this note?'),
                          content: const Text('Are you sure?'),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  await DBHelper.deleteMyNote(note['id']);
                                  onDelete();
                                  Navigator.pop(context);
                                },
                                child: const Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'))
                          ],
                        )));
              },
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditNoteScreen(
                    id: note['id'],
                    title: note['title'],
                    description: note['description'],
                  ),
                ),
              );
              if (result == null) {
                onEdit();
              }
            },
          );
        },
      ),
    );
  }
}
