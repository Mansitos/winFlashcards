import 'package:flutter/material.dart';
import 'package:study_cards/cards_utilities.dart';
import 'globals.dart' as globals;

// QCard Create-Modify Widget Form

class CardDialogForm extends StatefulWidget {
  const CardDialogForm({Key? key, required this.modifyMode}) : super(key: key);

  final bool modifyMode;

  @override
  State<CardDialogForm> createState() => CardDialogFormState();
}

class CardDialogFormState extends State<CardDialogForm> {
  final _formKey = GlobalKey<FormState>();

  String cardQuestion = "";
  String oldCardQuestion = "";

  String cardAnswer = "";
  String oldCardAnswer = "";

  @override
  Widget build(BuildContext context) {
    String title = "Create new Flashcard for category ${globals.selectedCategory!.name}";
    if (widget.modifyMode == true) {
      // TODO: ... modify mode to implement
      //oldCardQuestion = globals.categories[widget.modifyIndex].name;
    }

    double maxWidthAllowed = 575;
    double maxHeightAllowed = 300;

    return AlertDialog(
      title: Text(title),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 100, maxWidth: maxWidthAllowed, maxHeight: maxHeightAllowed, minHeight: 50),
            child: SizedBox(
              height: maxHeightAllowed,
              width: maxWidthAllowed,
              child: Theme(
                data: Theme.of(context).copyWith(textSelectionTheme: const TextSelectionThemeData(selectionColor: Colors.blueAccent)),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.blueAccent,
                      style: const TextStyle(fontSize: 18),
                      maxLength: 200,
                      initialValue: (() {
                        if (widget.modifyMode == true) {
                          return oldCardQuestion;
                        } else {
                          return '';
                        }
                      }()),
                      decoration: const InputDecoration(
                        hintText: 'What\'s the flashcard question?',
                        labelText: 'Flashcard question',
                        labelStyle: TextStyle(fontSize: 16, color: Colors.black45),
                        hintStyle: TextStyle(fontSize: 16, color: Colors.black45),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                      ),
                      onSaved: (String? value) {
                        setState(() {});
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text!';
                        } else if (value.contains("\$") || value.contains("|")) {
                          return 'Invalid characters! \$ and | are not allowed!';
                        } else {
                          cardQuestion = value;
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 210,
                      child: TextFormField(
                        cursorColor: Colors.blueAccent,
                        style: const TextStyle(fontSize: 18),
                        maxLength: 20000,
                        maxLines: 10,
                        initialValue: (() {
                          if (widget.modifyMode == true) {
                            return oldCardAnswer;
                          } else {
                            return '';
                          }
                        }()),
                        decoration: const InputDecoration(
                          hintText: 'What\'s the flashcard answer?',
                          labelText: 'Flashcard answer',
                          labelStyle: TextStyle(fontSize: 16, color: Colors.black45),
                          hintStyle: TextStyle(fontSize: 16, color: Colors.black45),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                        ),
                        onSaved: (String? value) {
                          setState(() {});
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text!';
                          } else if (value.contains("\$") || value.contains("|")) {
                            return 'Invalid characters! \$ and | are not allowed!';
                          } else {
                            cardAnswer = value.replaceAll("\n", " ");
                            ;
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
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
                    setState(() {
                      debugPrint("Confirm QCard creation/modify button pressed!");
                      if (_formKey.currentState!.validate()) {
                        debugPrint("Ok! Valid QCard form!");
                        if (widget.modifyMode == false) {
                          Navigator.of(context).pop();
                          createNewQCard(cardQuestion, cardAnswer);
                        } else {
                          Navigator.of(context).pop();
                          //modifyQCard(widget.modifyIndex, cardQuestion, QCardEmoji);
                        }
                      } else {
                        debugPrint("Error! Validation failed in QCard creation form!");
                      }
                    });
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
