import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:shoping_grocery/data/dummy_item.dart';
import 'package:shoping_grocery/models/grocery_item.dart';

class ListBodys extends StatefulWidget {
   const ListBodys({super.key,required this.groceryItems});
  final List<GroceryItem> groceryItems;
  @override
  State<ListBodys> createState() => _ListBodysState();
}

class _ListBodysState extends State<ListBodys> {

  void _removeItem(GroceryItem item)async{
     final url = Uri.https(
      "flutter-prep-3dd2f-default-rtdb.firebaseio.com",
      'shopping-list/${item.id}.json',
    );
    final response = await http.delete(url);
    if(response.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("removed successfully!"),
          ));
    }
    else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("failed: ${response.statusCode}"),
          ));
    }
    setState(() {
      widget.groceryItems.removeWhere((items)=>items.id==item.id);
    });
  }

  @override
  
  Widget build(BuildContext context) {
    
    return widget.groceryItems.isEmpty?Center(child: Text("No item added yet!"),)
    :ListView.builder(
      itemCount:widget.groceryItems.length ,
      
      itemBuilder: (context,index)=>Dismissible(
        onDismissed: (direction){
          _removeItem(widget.groceryItems[index]);
        },
        key: ValueKey(widget.groceryItems[index]), 
        child: ListTile(
          title: Text(widget.groceryItems[index].name),
          leading: Container(
            height: 24,
            width: 24,
            color: widget.groceryItems[index].category.color,
          ),
          trailing: Text(widget.groceryItems[index].quantity.toString()),
        )
        )
    );
  }
}