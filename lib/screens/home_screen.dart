import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoping_grocery/data/categories.dart';
import 'package:shoping_grocery/models/grocery_item.dart';
import 'package:shoping_grocery/widgets/home_body.dart';
import 'package:shoping_grocery/widgets/new_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   List<GroceryItem> _groceryItems = [];
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      "flutter-prep-3dd2f-default-rtdb.firebaseio.com",
      'shopping-list.json',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final _loadItems=[];
      for (var item in data.entries) {
        final cate = Categories.values.byName(
          item.value['category'].toLowerCase(),
        );
        final groceryItem = GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: categories[cate]!,
        );
        _loadItems.add(groceryItem);
      }
      setState(() {
        _groceryItems.addAll([..._loadItems]);
      });
    }
  }

  void addItem()  {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewItem()));
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [IconButton(onPressed: addItem, icon: Icon(Icons.add))],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListBodys(groceryItems: _groceryItems),
      ),
    );
  }
}
