import 'package:flutter/material.dart';

typedef DraftShareAddedCallback = Function(
    String file, String editcontents, TextEditingController textController);
// valuetext (below) needs to be whatever the editing page is pulling from the file. So, look down to 
// class _DraftShareFileEditState to make sure that valuetext is made form the contents of "file".
// "file" is probably not going to be a String.
class DraftShareFileEdit extends StatefulWidget {
  const DraftShareFileEdit({
    super.key,
    required this.file,
    required this.onFileChanged,
  });

  final String file;
  final DraftShareAddedCallback onFileChanged;

  @override
  State<DraftShareFileEdit> createState() => _DraftShareFileEditState();
}

class _DraftShareFileEditState extends State<DraftShareFileEdit> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  // final TextEditingController _inputController = TextEditingController()..text = widget.item.name;
  TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  String valueText = "";
  @override
  void initState() {
    super.initState();
// vvvvv Edit this so that valueText and text matches the contents of the file, not the file itself.
    valueText = widget.file;
    _inputController = TextEditingController(text: widget.file);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Draft:'),
      content: TextField(
        onChanged: (editcontents) {
          setState(() {
            valueText = editcontents;
          });
        },
        controller: _inputController,
        decoration: const InputDecoration(hintText: "Empty. Press Cancel to restore text."),
      ),
      actions: <Widget>[
        ElevatedButton(
          key: const Key("CancelButton"),
          style: noStyle,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          child: const Text('Cancel'),
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
                        widget.onFileChanged(widget.file, valueText, _inputController);
                        Navigator.pop(context);
                      });
                    }
                  : null,
              child: const Text('OK'),
            );
          },
        ),
      ],
    );
  }
}
