# CloudyOutlookGroup2

Initial Pull Test: Jaxon

## Usage notes for backend

Backend: `lib/docstoragetestjaxon.dart` (Firestore collection: `documents`) 
naming can be changed later

```dart
final storage = DocumentStorage();

storage.watchDocuments()                              // Stream<List<TextDocument>> - for the list screen
storage.watchDocument(id)                             // Stream<TextDocument> - for the editor screen
storage.createDocument(title, content)                // returns the new doc's id
storage.updateDocument(id, title: ..., content: ...)  // save changes
storage.deleteDocument(id)
```

`TextDocument` fields: `id`, `title`, `content`, `updatedAt`

Example usage: `lib/doctestingtestjaxon.dart` (`DocumentTestPage`) 
naming can be changed later/can be deleted after final app made, just for testing flow of backend

- New document = `createDocument` (keep the returned id)
- Existing document = `updateDocument(id, ...)`

Other notes/resources used:
https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0
https://firebase.google.com/docs/flutter/setup?authuser=0#android

