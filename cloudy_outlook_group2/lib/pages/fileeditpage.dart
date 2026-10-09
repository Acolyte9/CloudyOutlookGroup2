import 'package:flutter/material.dart';
import 'package:cloudy_outlook_group2/docstoragetestjaxon.dart';

// typedef DraftShareAddedCallback = Function(
//     TextDocument file, String editcontents, TextEditingController textController);


class DraftShareFileEdit extends StatefulWidget {
  const DraftShareFileEdit({
    super.key,
    required this.file,
    // required this.onFileChanged,
    required this.storage,
    // The file is the specific thing we're changing, and it contains the document - including title and contents.
    // The storage is the connection to the cloud, and we need it if we want to update the document in firebase.
  });

  final TextDocument file;
  // final DraftShareAddedCallback onFileChanged;
  final DocumentStorage storage;

  @override
  State<DraftShareFileEdit> createState() => _DraftShareFileEditState();
}

class _DraftShareFileEditState extends State<DraftShareFileEdit> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  // final TextEditingController _inputController = TextEditingController()..text = widget.item.name;
  TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.blue);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  String valueText = "";
  @override
  void initState() {
    super.initState();
// vvvvv This should have it so that the contents of the new page match the contents of the opened file.
//        Without this stuff, the page would always be blank even if we got it to save over whatever it tried to open.
    valueText = widget.file.content;
    _inputController = TextEditingController(text: widget.file.content);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.title),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 192, 128),
        foregroundColor: const Color.fromARGB(255, 255, 224, 194),
        actions: <Widget>[
          ElevatedButton(
            key: const Key("CancelButton"),
            style: noStyle,
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: const Text('Exit'),
          ),
          // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _inputController,
            builder: (context, editcontents, child) {
              return ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                onPressed: editcontents.text.isNotEmpty
                    ? () {
                        setState(() {
                          // vvv This should be able to update the file to the cloud from within this screen, without exiting back to the main menu.
                          // widget.onFileChanged(widget.file, valueText, _inputController);
                          widget.storage.updateDocument(widget.file.id, title: widget.file.title, content: valueText);
                          // Navigator.pop(context);
                        });
                      }
                    : null,
                child: const Text('SAVE'),
              );
            },
          ),
        ],
      ),
      body: Center(
        // title: const Text('Edit Draft:'),
        child: TextField(
          onChanged: (editcontents) {
            setState(() {
              valueText = editcontents;
            });
          },
          controller: _inputController,
          decoration: const InputDecoration(hintText: "Empty. Press Exit to restore text."),
        ),
      ),
      
    );
  }
}
