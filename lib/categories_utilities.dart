import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_cards/generic_utilities.dart';
import 'category.dart';
import 'globals.dart' as globals;

Future<void> createNewCategory(String name) async {
  name = name.capitalize();

  Category newCategory = Category(name: name);
  globals.categories.add(newCategory);
  debugPrint("\n > New category saved!\n${serializeCategory(newCategory)}");
  await globals.categoriesStorage.saveCategoriesToFile(globals.categories);
}

Future<void> modifyCategory(int index, String name) async {
  name = name.capitalize();

  Category modified = Category(name: name);
  debugPrint("\n > Modify class with index $index");
  globals.categories[index] = modified;
  debugPrint("Now categories are: ${globals.categories}");
  globals.categoriesStorage.saveCategoriesToFile(globals.categories);

}


Future<void> deleteCategory(int index) async {
  debugPrint("\n > Delete class with index $index");
  globals.categories.removeAt(index);
  debugPrint("Now categories are: ${globals.categories}");
  globals.categoriesStorage.saveCategoriesToFile(globals.categories);
}

Category decodeSerializedCategory(String encode) {
  String name = encode;
  return Category(name: name);
}

String serializeCategory(Category category) {
  return category.name;
}

bool checkIfCategoryNameAvailable(String name, String emoji, String mask, bool maskMode) {
  name = name.capitalize();

  for (var i = 0; i < globals.categories.length; i++) {
    if (maskMode == true) {
      if (name != mask && emoji != mask) {
        if (name == globals.categories[i].name) {
          debugPrint(" > Cannot create/modify category! emoji or name already used");
          return false;
        }
      }
    } else {
      if (name == globals.categories[i].name) {
        debugPrint(" > Cannot create/modify category! emoji or name already used");
        return false;
      }
    }
  }
  return true;
}
