import 'package:flutter/material.dart';
import 'docstoragetestjaxon.dart';

class DocumentTestPage extends StatefulWidget {
  const DocumentTestPage({super.key});

  @override
  State<DocumentTestPage> createState() => _DocumentTestPageState();
}

class _DocumentTestPageState extends State<DocumentTestPage> {
  final _storage = DocumentStorage();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedId; // null = a new, unsaved document

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _select(TextDocument doc) {
    setState(() {
      _selectedId = doc.id;
      _titleController.text = doc.title;
      _contentController.text = doc.content;
    });
  }

  void _clear() {
    setState(() {
      _selectedId = null;
      _titleController.clear();
      _contentController.clear();
    });
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _save() async {
    final title = _titleController.text.trim().isEmpty
        ? 'Untitled'
        : _titleController.text.trim();
    try {
      if (_selectedId == null) {
        final id = await _storage.createDocument(title, _contentController.text);
        setState(() => _selectedId = id);
      } else {
        await _storage.updateDocument(
          _selectedId!,
          title: title,
          content: _contentController.text,
        );
      }
      _showMessage('Saved');
    } catch (e) {
      _showMessage('Save failed: $e');
    }
  }

  Future<void> _delete() async {
    final id = _selectedId;
    if (id == null) return;
    try {
      await _storage.deleteDocument(id);
      _clear();
      _showMessage('Deleted');
    } catch (e) {
      _showMessage('Delete failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(onPressed: _clear, child: const Text('New')),
                const SizedBox(width: 8),
                FilledButton(onPressed: _save, child: const Text('Save')),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _selectedId == null ? null : _delete,
                  child: const Text('Delete'),
                ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: StreamBuilder<List<TextDocument>>(
                stream: _storage.watchDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final docs = snapshot.data ?? [];
                  if (docs.isEmpty) {
                    return const Text('No documents yet');
                  }
                  return ListView(
                    children: [
                      for (final doc in docs)
                        ListTile(
                          title: Text(doc.title),
                          subtitle: Text(
                            doc.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          selected: doc.id == _selectedId,
                          onTap: () => _select(doc),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}