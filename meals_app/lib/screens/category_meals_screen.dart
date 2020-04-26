import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String _categoryTitle;
  List<Meal> _displayedMeals;
  var _loadedInitData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedInitData) return;

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    _categoryTitle = routeArgs['title'];
    final _categoryId = routeArgs['id'];
    _displayedMeals = widget.availableMeals.where((meal) {
      return meal.categories.contains(_categoryId);
    }).toList();
    _loadedInitData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_categoryTitle),
      ),
      body: ListView.builder(
        itemCount: _displayedMeals.length,
        itemBuilder: (ctx, index) {
          return MealItem(
            id: _displayedMeals[index].id,
            title: _displayedMeals[index].title,
            affordability: _displayedMeals[index].affordability,
            complexity: _displayedMeals[index].complexity,
            duration: _displayedMeals[index].duration,
            imageUrl: _displayedMeals[index].imageUrl,
          );
        },
      ),
    );
  }
}
