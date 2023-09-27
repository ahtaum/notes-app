import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/tabs/notes/noteDetail.dart';
import 'addNotes.dart';
import 'editNotes.dart';

class Notes extends StatelessWidget {
  // Process
  static String truncateDescription(String description) {
    if (description.length <= 30) {
      return description;
    }
    
    return '${description.substring(0, 30)}...';
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String documentId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final result = await _deleteNote(documentId);
                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Note deleted successfully'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color.fromARGB(255, 33, 243, 110),
                    ),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _deleteNote(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('dummy').doc(documentId).delete();

      return true;
    } catch (e) {
      print('Error deleting note: $e');
      
      return false;
    }
  }

  // Pages
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dummy').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No data available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final document = snapshot.data!.docs[index];
              final title = document['title'];
              final description = truncateDescription(document['description']);
              final createdAt = document['created_at'] != null
                  ? (document['created_at'] as Timestamp).toDate()
                  : null;
              final createdAtString = createdAt != null
                  ? "${createdAt.day} ${_getMonthName(createdAt.month)} ${createdAt.year}"
                  : "";

              return Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description),
                      if (createdAtString.isNotEmpty) Text(createdAtString),
                    ],
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NoteDetail(document),
                      ),
                    );
                  },
                  // Ganti ikon delete dengan ikon edit (pensil)
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit), // Ikon edit (pensil)
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditNote(document), // Mengarahkan ke halaman EditNote
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete), // Ikon delete
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, document.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  String _getMonthName(int month) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April',
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember'
    ];

    return months[month - 1];
  }
}
