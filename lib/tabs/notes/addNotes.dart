import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  // Process
  Future<void> _addNote() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      // Validasi input
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Title and description are required.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      return;
    }

    // Menampilkan loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      final docRef = await FirebaseFirestore.instance.collection('dummy').add({
        'title': title,
        'description': description,
        'created_at': FieldValue.serverTimestamp(), // Tambahkan field created_at
      });

      // Mengambil ID dokumen yang baru ditambahkan
      final newNoteId = docRef.id;

      // Menyimpan ID bersama dengan data catatan
      await FirebaseFirestore.instance.collection('dummy').doc(newNoteId).update({
        'id': newNoteId,
      });

      // Menampilkan snackbar setelah berhasil menambahkan catatan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note added successfully'),
          duration: Duration(seconds: 2), // Durasi tampilan snackbar
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green, // Warna latar belakang snackbar
        ),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } catch (e) {
      print('Error adding note: $e');
    } finally {
      // Menyembunyikan loading indicator setelah selesai
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Pages
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
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
              onPressed: _isLoading ? null : _addNote, // Menonaktifkan tombol saat loading
              child: _isLoading
                  ? CircularProgressIndicator() // Menampilkan loading indicator saat loading
                  : Text('Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}