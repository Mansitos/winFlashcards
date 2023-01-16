import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'card.dart';
import 'cards_utilities.dart';
import 'category.dart';
import 'globals.dart' as globals;

// This class handle/allows Cards persistency over sessions.
// The class provides file save/load mechanism for Cards.

class CardsStorage {
// Getting the local documents path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localCardsFile(String categoryName) async {
    final path = await _localPath;

    File file = File('$path/$categoryName.txt');

    if (file.existsSync()) {
      return file;
    } else {
      debugPrint(" > Creating cards file for category $categoryName because it was missing!");
      file = await File('$path/$categoryName.txt').create(recursive: true);
      if (file.existsSync()) {}
    }
    return file;
  }

  Future<File> saveCardsToFile(Category category, List<QCard> cards) async {
    final file = await _localCardsFile(category.name);

    String encode = "";
    if (cards.isNotEmpty) {
      for (int i = 0; i <= cards.length - 1; i++) {
        encode += serializeQCard(cards[i]);
        encode += '|';
      }
      encode = encode.substring(0, encode.length - 1); // Remove last separator
    }

    debugPrint("\n > Cards saved successfully! location/path: ${file.path}");
    debugPrint(cards.toString());
    return file.writeAsString(encode);
  }

  Future<bool> loadCardsFromFile(Category category) async {
    try {
      final file = await _localCardsFile(category.name);
      final contents = await file.readAsString();

      List<String> encodedCards = contents.split('|');
      List<QCard> cards = [];

      if(contents.length > 1) {
        for (var i = 0; i < encodedCards.length; i++) {
          cards.add(decodeSerializedQCard(encodedCards[i]));
        }
      }

      // Updating globals entry
      globals.loadedCards = cards;
      debugPrint(" > Cards loaded successfully! (${cards.length})");
      debugPrint(cards.toString());
      return true;
    } catch (e) {
      debugPrint(" > Error in loading Cards file!");
      debugPrint(e.toString());
      return false;
    }
  }
}
