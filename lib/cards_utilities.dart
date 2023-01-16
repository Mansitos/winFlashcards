import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_cards/generic_utilities.dart';
import 'globals.dart' as globals;
import 'card.dart';

Future<void> createNewQCard(String question, String answer) async {
  question = question.capitalize(); // TODO: only first let
  question = question.capitalize(); // TODO: only first let

  QCard newQCard = QCard(question: question, answer: answer);
  globals.loadedCards.add(newQCard);
  debugPrint("\n > New QCard saved!\n${serializeQCard(newQCard)}");

  globals.cardsStorage.saveCardsToFile(globals.selectedCategory!, globals.loadedCards);
}

Future<void> modifyQCard(int index, String question, String answer) async {
  question = question.capitalize(); // TODO: only first let
  question = question.capitalize(); // TODO: only first let

  QCard modified = QCard(question: question, answer: answer);
  debugPrint("\n > Modify QCard with index $index");
  globals.loadedCards[index] = modified;
  debugPrint("Now QCards are: ${globals.loadedCards}");

  globals.cardsStorage.saveCardsToFile(globals.selectedCategory!, globals.loadedCards);
}


Future<void> deleteQCard(int index) async {
  debugPrint("\n > Delete QCard with index $index");
  globals.loadedCards.removeAt(index);
  debugPrint("Now QCards are: ${globals.loadedCards}");

  globals.cardsStorage.saveCardsToFile(globals.selectedCategory!, globals.loadedCards);
}

QCard decodeSerializedQCard(String encode) {
  List<String> data = encode.split('\$');
  return QCard(question: data[0], answer: data[1]);
}

String serializeQCard(QCard card) {
  return "${card.question}\$${card.answer}";
}

bool checkIfQCardNameAvailable(String name, String emoji, String mask, bool maskMode) {
  name = name.capitalize();

  for (var i = 0; i < globals.categories.length; i++) {
    if (maskMode == true) {
      if (name != mask && emoji != mask) {
        if (name == globals.categories[i].name) {
          debugPrint(" > Cannot create/modify QCard! question already used");
          return false;
        }
      }
    } else {
      if (name == globals.categories[i].name) {
        debugPrint(" > Cannot create/modify QCard! question already used");
        return false;
      }
    }
  }
  return true;
}
