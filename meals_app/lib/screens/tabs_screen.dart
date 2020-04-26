import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import './categories_screen.dart';
import './favorites_screen.dart';
import '../models/meal.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;

  TabsScreen(this.favoriteMeals);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  List<Map<String, dynamic>> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': CategoriesScreen(),
        'title': 'Categories',
        'icon': Icons.category,
      },
      {
        'page': FavoritesScreen(widget.favoriteMeals),
        'title': 'Your Favorites',
        'icon': Icons.star,
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  List<BottomNavigationBarItem> get buildBottomNavigationBarItems {
    List<BottomNavigationBarItem> items = [];
    for (var i = 0; i < _pages.length; i++) {
      items.add(BottomNavigationBarItem(
        icon: Icon(_pages[i]['icon']),
        title: Text(
          _pages[i]['title'],
        ),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_selectedPageIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          page['title'],
        ),
      ),
      drawer: MainDrawer(),
      body: page['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        items: buildBottomNavigationBarItems,
      ),
    );
  }
}
