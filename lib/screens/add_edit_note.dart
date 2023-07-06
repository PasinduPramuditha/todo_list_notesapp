import 'package:flutter/material.dart';

import '../database_helper/db_helper.dart';

class AddEditNoteScreen extends StatefulWidget {
  final int? id;
  final String? title;
  final String? description;

  const AddEditNoteScreen({
    this.id,
    this.title,
    this.description,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String get title => _titleController.text;
  String get description => _descriptionController.text;
  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      // title is the same as the note title
      _titleController.text = widget.title!;
      _descriptionController.text = widget.description!;
    }

    if (widget.id == null) {
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.id == null ? Text('Add Note') : Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.text,
              maxLines: null,
              textAlign: TextAlign.center,
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                contentPadding: EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Start typing...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (widget.id == null) {
                      // add the note to the database

                      try {
                        if (_titleController.text.isEmpty) {
                          throw Exception("Title cannot be empty");
                        }
                        if (_descriptionController.text.isEmpty) {
                          throw Exception("Description cannot be empty");
                        } else {
                          DBHelper.insertMyNote(
                            _titleController.text,
                            _descriptionController.text,
                          );
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      }
                    } else {
                      // update the note in the database
                      try {
                        if (_titleController.text.isEmpty) {
                          throw Exception("Title cannot be empty");
                        }
                        if (_descriptionController.text.isEmpty) {
                          throw Exception("Description cannot be empty");
                        } else {
                          DBHelper.updateMyNote(
                            widget.id!,
                            _titleController.text,
                            _descriptionController.text,
                          );
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      }
                      // DBHelper.updateMyNote(
                      //   widget.id!,
                      //   _titleController.text,
                      //   _descriptionController.text,
                      // );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
