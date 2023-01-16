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
                child: Text(
                  widget.qCard.question,
                  textAlign: TextAlign.center,
                  style: questionStyle,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.qCard.question,
                    style: questionStyleFlipped,
                  ),
                  Container(height: 10),
                  Text(
                    widget.qCard.answer,
                    style: answerStyle,
                  ),
                ],
              ),
      ),
    );
  }
}
