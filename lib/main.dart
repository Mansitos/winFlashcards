import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:study_cards/card_form_dialog.dart';
import 'package:study_cards/qcard_widget.dart';
import 'category_form_dialog.dart';
import 'globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  await globals.categoriesStorage.loadCategoriesFromFile();

  if (globals.categories.isNotEmpty) {
    globals.selectedCategory = globals.categories[0];
    globals.cardsStorage.loadCardsFromFile(globals.selectedCategory!);
  } else {
    debugPrint(" > There are no categories, no cards to load!");
  }
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
                child: ListView(
                  children: _getSideDrawerHeaderWidget() + listOfCategoriesBuilder(context) + createCategoryButton(),
                ),
              ),
            ),
            cardsGridViewer(),
          ],
        ));
  }

  List<Widget> listOfCategoriesBuilder(BuildContext context) {
    List<Widget> categoriesTiles = [];

    TextStyle style = const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400);
    TextStyle selectedStyle = const TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w500);
    Widget divider = const Divider(
      thickness: 2,
    );

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
                Icons.eleven_mp,
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

  List<Widget> _getSideDrawerHeaderWidget() {
    TextStyle titleStyle = const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w500);

    return <Widget>[
      Row(
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
      ),
    ];
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
                  }).then((_) => setState(() {}));
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
    return Flexible(
        fit: FlexFit.tight,
        child: Container(
          color: Colors.black87,
          child: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: _CardsListItemsBuilder(),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> _CardsListItemsBuilder() {
    List<Widget> cardsWidgets = [];

    for (int i = 0; i <= globals.loadedCards.length - 1; i++) {
      Widget cardWidget = QCardWidget(qCard: globals.loadedCards[i]);
      cardsWidgets.add(cardWidget);
    }

    return cardsWidgets;
  }
}
