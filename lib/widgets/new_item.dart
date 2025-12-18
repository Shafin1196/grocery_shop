import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:shoping_grocery/data/categories.dart';
import 'package:shoping_grocery/screens/home_screen.dart';


class NewItem extends StatefulWidget {
  NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _fromKey = GlobalKey<FormState>();
  var _enteredName = ' ';
  var _enteredQuantity = 0;
  var _selecetedCategory = categories[Categories.vegetables]!;
  void _saveItem() async{
    if (_fromKey.currentState!.validate()) {
      _fromKey.currentState!.save();
      final url=Uri.https("flutter-prep-3dd2f-default-rtdb.firebaseio.com",'shopping-list.json');
      final response=await http.post(
        url,
        headers: {
          'Content-Type':'application/json',
        },
        body: json.encode(
          {
          "name": _enteredName,
          "quantity": _enteredQuantity,
          "category": _selecetedCategory.name,
          }
        ),
      );
      if(response.statusCode==200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("added successfully"),
          ));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Home()));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed: ${response.statusCode}"),
          ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a new item")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _fromKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Must be between 1 and 50 characters";
                  }
                  return null;
                },
                onSaved: (newValue) => _enteredName = newValue!,
                decoration: InputDecoration(label: Text("Name")),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: "1",
                      decoration: InputDecoration(label: Text("Quantity")),
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) =>
                          _enteredQuantity = int.parse(newValue!),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Must be a valid positive number";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selecetedCategory,

                      items: [
                        for (final item in categories.entries)
                          DropdownMenuItem(
                            value: item.value,
                            child: Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 16,
                                  color: item.value.color,
                                ),
                                SizedBox(width: 6),
                                Text(item.value.name),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selecetedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _fromKey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: _saveItem, child: Text("Add Item")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
