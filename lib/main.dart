import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:study_cards/card_form_dialog.dart';
import 'package:study_cards/qcard_widget.dart';
import 'package:study_cards/settings_dialog.dart';
import 'category_form_dialog.dart';
import 'globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await globals.categoriesStorage.loadCategoriesFromFile();

  if (globals.categories.isNotEmpty) {
    globals.selectedCategory = globals.categories[0];
    globals.cardsStorage.loadCardsFromFile(globals.selectedCategory!);
  } else {
    debugPrint(" > There are no categories, no cards to load!");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const double maxSideContainerWidth = 325;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SizedBox(
          height: 80,
          child: FloatingActionButton.large(
            onPressed: () {
              debugPrint(" > Create FlashCard Button Pressed!");
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CardDialogForm(modifyMode: false);
                    }).then((_) => setState(() {}));
              });
            },
            child: const Icon(Icons.add),
          ),
        ),
        body: Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: maxSideContainerWidth),
              child: Container(
                width: maxSideContainerWidth,
                height: MediaQuery.of(context).size.height,
                color: Colors.blue,
                child: Column(
                  children: [
                    _getSideDrawerHeaderWidget(),
                    Expanded(
                      child: ListView(
                        children: listOfCategoriesBuilder(context) + createCategoryButton(),
                      ),
                    ),
                    _getSideDrawerBottomWidget(),
                  ],
                ),
              ),
            ),
            _mainGridWidget(),
          ],
        ));
  }

  List<Widget> listOfCategoriesBuilder(BuildContext context) {
    List<Widget> categoriesTiles = [];

    TextStyle style = const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400);
    TextStyle selectedStyle = const TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w500);
    Widget divider = const Divider(thickness: 2);

    categoriesTiles.add(divider);

    for (var i = 0; i < globals.categories.length; i++) {
      Widget categoryTile = TextButton(
          onPressed: () async {
            debugPrint(" > Selected category:${globals.categories[i].name}");
            globals.selectedCategory = globals.categories[i];
            await globals.cardsStorage.loadCardsFromFile(globals.selectedCategory!);
            setState(() {});
          },
          child: Row(
            children: [
              const Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  globals.categories[i].name,
                  style: globals.categories[i].name != globals.selectedCategory!.name ? style : selectedStyle,
                ),
              ),
            ],
          ));
      categoriesTiles.add(categoryTile);
      categoriesTiles.add(divider);
    }
    return categoriesTiles;
  }

  Widget _getSideDrawerHeaderWidget() {
    TextStyle titleStyle = const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w500);

    return Row(
      children: [
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset("lib/assets/logo.png"),
          ),
        ),
        Text(
          "WinFlashcards",
          style: titleStyle,
        ),
      ],
    );
  }

  List<Widget> createCategoryButton() {
    return <Widget>[
      SizedBox(
        height: 30,
        child: FloatingActionButton.small(
          onPressed: () {
            debugPrint(" > Create Category Button Pressed!");
            setState(() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CategoryDialogForm(modifyMode: false);
                  }).then((_) => setState(() {
                    globals.selectedCategory ??= globals.categories[0];
                  }));
            });
          },
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.blueAccent,
          ),
        ),
      )
    ];
  }

  Widget cardsGridViewer() {
    double pad = 5;

    return Flexible(
        fit: FlexFit.tight,
        child: Container(
          color: Colors.black87,
          child: Padding(
            padding: EdgeInsets.all(pad * 2),
            child: GridView.builder(
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: pad,
                mainAxisSpacing: pad,
                childAspectRatio: globals.squaredView == true ? (1 / 1) : (1.33 / 1),
              ),
              itemCount: globals.loadedCards.length,
              itemBuilder: (BuildContext context, int index) {
                return _flashcardGridItemBuilder(index);
              },
            ),
          ),
        ));
  }

  Widget _flashcardGridItemBuilder(int index) {
    Widget cardWidget = QCardWidget(qCard: globals.loadedCards[index]);
    return cardWidget;
  }

  _mainGridWidget() {
    if (globals.loadedCards.isNotEmpty) {
      return cardsGridViewer();
    } else {
      String text = globals.categories.isNotEmpty ? "No flashcards for this category!\nPress the + button on the bottom right." : "No categories found!\nPress the + button on the left side-drawer.";
      TextStyle textStyle = const TextStyle(fontSize: 30, color: Colors.white);

      return Flexible(
        fit: FlexFit.tight,
        child: Container(
          color: Colors.black87,
          child: Center(
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  Widget _getSideDrawerBottomWidget() {
    double fontSize = 15;
    double pad = 2;

    Color col = Colors.white;
    TextStyle style = TextStyle(fontSize: fontSize, color: col, fontWeight: FontWeight.w100);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton.icon(
            onPressed: () {
              debugPrint(" > Settings Button Pressed!");
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CategoryDialogForm(modifyMode: false);
                    }).then((_) => setState(() {
                }));
              });
            },
            icon: Icon(Icons.settings, size: fontSize - 1, color: col),
            label: Padding(
              padding: EdgeInsets.only(bottom: pad),
              child: Text("settings", style: style),
            )),
        TextButton.icon(
            onPressed: () {
              debugPrint(" > About Button Pressed!");
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SettingsDialog();
                    }).then((_) => setState(() {}));
              });
            },
            icon: Icon(Icons.info_outline, size: fontSize - 1, color: col),
            label: Padding(
              padding: EdgeInsets.only(bottom: pad),
              child: Text("about", style: style),
            )),
      ],
    );
  }
}
