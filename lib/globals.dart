// Categories global variables
import 'package:study_cards/cards_storage.dart';

import 'card.dart';
import 'categories_storage.dart';
import 'category.dart';

final CategoriesStorage categoriesStorage = CategoriesStorage();
final CardsStorage cardsStorage = CardsStorage();
List<Category> categories = [];
List<QCard> loadedCards = [];
Category? selectedCategory;