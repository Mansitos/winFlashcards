import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_cards/card.dart';

class QCardWidget extends StatefulWidget {
  const QCardWidget({Key? key, required this.qCard}) : super(key: key);

  final QCard qCard;

  @override
  State<QCardWidget> createState() => QCardWidgetState();
}

class QCardWidgetState extends State<QCardWidget> {
  bool flipped = false;

  TextStyle questionStyle = const TextStyle(fontSize: 35);
  TextStyle questionStyleFlipped = const TextStyle(fontSize: 22);
  TextStyle answerStyle = const TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          debugPrint('Card flipped');
          flipped = !flipped;
          setState(() {});
        },
        child: flipped == false
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.qCard.question,
                    textAlign: TextAlign.center,
                    style: questionStyle,
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.qCard.question,
                      textAlign: TextAlign.center,
                      style: questionStyleFlipped,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10,),
                    child: Text(
                      widget.qCard.answer,
                      textAlign: TextAlign.center,
                      style: answerStyle,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
