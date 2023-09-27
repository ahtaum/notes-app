import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNote extends StatefulWidget {
  final DocumentSnapshot document;

  EditNote(this.document);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.document['title'];
    _descriptionController.text = widget.document['description'];
  }

  // Process
  Future<void> _updateNote() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    try {
      await FirebaseFirestore.instance
          .collection('dummy')
          .doc(widget.document.id)
          .update({
        'title': title,
        'description': description,
        'created_at': FieldValue.serverTimestamp(), // Tambahkan field created_at saat update
      });

      // Menampilkan snackbar setelah berhasil mengupdate catatan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note updated successfully'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue,
        ),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  // Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateNote,
              child: Text('Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}
