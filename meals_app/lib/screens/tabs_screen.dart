import 'package:flutter/material.dart';

import './categories_screen.dart';
import './favorites_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, dynamic>> _pages = [
    {
      'page': CategoriesScreen(),
      'title': 'Categories',
      'icon': Icons.category,
    },
    {
      'page': FavoritesScreen(),
      'title': 'Your Favorites',
      'icon': Icons.star,
    },
  ];

  int _selectedPageIndex = 0;

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
