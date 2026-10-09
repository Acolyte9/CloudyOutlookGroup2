import 'package:cloud_firestore/cloud_firestore.dart';

class TextDocument {
  TextDocument({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String content;
  final int updatedAt;

  factory TextDocument.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TextDocument(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled',
      content: data['content'] as String? ?? '',
      updatedAt: data['updatedAt'] as int? ?? 0,
    );
  }
}

class DocumentStorage {
  final _docs = FirebaseFirestore.instance.collection('documents');

  /// Live list of all documents, newest edit first (for the document list screen).
  Stream<List<TextDocument>> watchDocuments() {
    return _docs
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(TextDocument.fromSnapshot).toList());
  }

  /// Live version of one document (for the editor screen).
  Stream<TextDocument> watchDocument(String id) {
    return _docs.doc(id).snapshots().map(TextDocument.fromSnapshot);
  }

  /// Create a new document and return its id.
  Future<String> createDocument(String title, String content) async {
    final ref = await _docs.add({
      'title': title,
      'content': content,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
    return ref.id;
  }

  /// Save edits back to the cloud.
  Future<void> updateDocument(String id, {String? title, String? content}) {
    return _docs.doc(id).update({
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Delete a document.
  Future<void> deleteDocument(String id) => _docs.doc(id).delete();
}