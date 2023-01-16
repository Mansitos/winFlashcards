import 'package:flutter/material.dart';
import 'package:study_cards/categories_utilities.dart';

// Category Create-Modify Widget Form

class CategoryDialogForm extends StatefulWidget {
  const CategoryDialogForm({Key? key, required this.modifyMode}) : super(key: key);

  final bool modifyMode;

  @override
  State<CategoryDialogForm> createState() => CategoryDialogFormState();
}

class CategoryDialogFormState extends State<CategoryDialogForm> {
  final _formKey = GlobalKey<FormState>();

  String categoryName = "";
  String oldCategoryName = "";

  @override
  Widget build(BuildContext context) {
    String title = "Create New Category";
    if (widget.modifyMode == true) {
      // TODO: ... modify mode to implement
      //oldCategoryName = globals.categories[widget.modifyIndex].name;
    }

    double maxWidthAllowed = 375;
    double maxHeightAllowed = 100;

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
                      maxLength: 20,
                      initialValue: (() {
                        if (widget.modifyMode == true) {
                          return oldCategoryName;
                        } else {
                          return '';
                        }
                      }()),
                      decoration: const InputDecoration(
                        hintText: 'What\'s the category name?',
                        labelText: 'Category name',
                        labelStyle: TextStyle(fontSize: 16, color: Colors.black45),
                        hintStyle: TextStyle(fontSize: 16, color: Colors.black45),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                      ),
                      onSaved: (String? value) {
                        setState(() {});
                      },
                      validator: (String? value) {
                        final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text!';
                        } else if (!validCharacters.hasMatch(value)) {
                          return 'Invalid characters!';
                        } else if (!checkIfCategoryNameAvailable(value, "", oldCategoryName, widget.modifyMode)) {
                          return 'Name already used!';
                        } else {
                          categoryName = value;
                          return null;
                        }
                      },
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
                  heroTag: "UndoCategory",
                  onPressed: () {
                    setState(() {
                      debugPrint("Undo category creation/modify button pressed!");
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
                  heroTag: "ConfirmCategory",
                  onPressed: () {
                    setState(() {
                      debugPrint("Confirm category creation/modify button pressed!");
                      if (_formKey.currentState!.validate()) {
                        debugPrint("Ok! Valid category form!");
                        if (widget.modifyMode == false) {
                          Navigator.of(context).pop();
                          createNewCategory(categoryName);
                        } else {
                          Navigator.of(context).pop();
                          //modifyCategory(widget.modifyIndex, categoryName, categoryEmoji);
                        }
                      } else {
                        debugPrint("Error! Validation failed in category creation form!");
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
