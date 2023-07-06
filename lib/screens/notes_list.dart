import 'package:flutter/material.dart';

import '../components/list_component.dart';
import '../components/search_component.dart';
import '../database_helper/db_helper.dart';
import 'add_edit_note.dart';

class NotesController extends StatefulWidget {
  const NotesController({super.key});

  @override
  State<NotesController> createState() => _NotesControllerState();
}

class _NotesControllerState extends State<NotesController> {
  List<Map<String, dynamic>> notes = [];

  void _refreshNotes() async {
    final data = await DBHelper.getMyNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
    // debug statement
    print('initState. notes.length = ${notes.length}');
  }

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // search notes
  void _searchNotes(String text) async {
    final data = await DBHelper.searchMyNotes(text);
    setState(() {
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          MySearchBar(
            controller: _searchController,
            onChanged: _searchNotes,
          ),
          MyListView(
            notes: notes,
            onDelete: _refreshNotes,
            onEdit: _refreshNotes,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
          if (result != true) {
            _refreshNotes();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
