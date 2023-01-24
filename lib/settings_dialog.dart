import 'package:flutter/material.dart';
import 'package:study_cards/cards_utilities.dart';
import 'globals.dart' as globals;


class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => SettingsDialogState();
}

class SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    String title = "Create new Flashcard for category ${globals.selectedCategory!.name}";


    double maxWidthAllowed = 575;
    double maxHeightAllowed = 300;

    return AlertDialog(
      title: Text(title),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Text("asd");

      }),
      actions: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  heroTag: "UndoQCard",
                  onPressed: () {
                    setState(() {
                      debugPrint("Undo QCard creation/modify button pressed!");
                      Navigator.of(context).pop();
                    });
                  },
                  tooltip: "Cancel",
                  child: const Icon(
                    Icons.cancel,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: "ConfirmQCard",
                  onPressed: () {
                    setState(() {});
                  },
                  tooltip: "Confirm",
                  child: const Icon(Icons.check),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
