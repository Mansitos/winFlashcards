class QCard {
  QCard({required this.question, required this.answer});

  String question;
  String answer;

  @override
  String toString() {
    return "$question-$answer";
  }
}
