// import 'package:to_dont_list/objects/item.dart';
import 'package:flutter/material.dart';

typedef ToDoListDeletedCallback = Function(
    String item
    );

class ToDoDeleteCheck extends StatefulWidget {
  const ToDoDeleteCheck({
    super.key,
    required this.item,
    required this.onDeleteItem,
  });

  final String item;
  // ToDoDeleteCheck(Item item) : item = item;
  final ToDoListDeletedCallback onDeleteItem;

  @override
  State<ToDoDeleteCheck> createState() => _ToDoDeleteCheckState();
}

class _ToDoDeleteCheckState extends State<ToDoDeleteCheck> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  // final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  // String valueText = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Item?'),
      // content: TextField(
      //   onChanged: (value) {
      //     setState(() {
      //       valueText = value;
      //     });
      //   },
      //   controller: _inputController,
      //   decoration: const InputDecoration(hintText: "type something here"),
      // ),
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

        ElevatedButton(
          key: const Key("OKButton"),
          style: yesStyle,
          onPressed: () {
            setState(() {
              widget.onDeleteItem(widget.item);
              Navigator.pop(context);
            });
          },
          child: const Text('OK'),
        ),
        
        // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
        // ValueListenableBuilder<TextEditingValue>(
        //   valueListenable: _inputController,
        //   builder: (context, value, child) {
        //     return ElevatedButton(
        //       key: const Key("OKButton"),
        //       style: yesStyle,
        //       onPressed: value.text.isNotEmpty
        //           ? () {
        //               setState(() {
        //                 widget.onDeleteItem(item);
        //                 Navigator.pop(context);
        //               });
        //             }
        //           : null,
        //       child: const Text('OK'),
        //     );
        //   },
        // ),
      ],
    );
  }
}
