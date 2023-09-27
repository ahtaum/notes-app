import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteDetail extends StatelessWidget {
  final DocumentSnapshot document;

  NoteDetail(this.document);

  @override
  Widget build(BuildContext context) {
    final title = document['title'];
    final description = document['description'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Note Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
