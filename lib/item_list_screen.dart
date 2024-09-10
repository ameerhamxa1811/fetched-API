import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'confirmation_screen.dart';

class ItemListScreen extends StatefulWidget {

  @override

  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {

  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  @override

  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {

      setState(() {
        items = json.decode(response.body);
        filteredItems = items;
        isLoading = false;
      });

    } else {
      throw Exception('Failed to load items');
    }
  }

  void filterItems(String query) {
    final filtered = items.where((item) {
      final title = item['title'].toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery);
    }).toList();

    setState(() {
      filteredItems = filtered;
    });
  }

  void _navigateToConfirmationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(child: Text('Item List')),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
           children: [
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterItems,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
           Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredItems[index]['title']),
                  subtitle: Text(filteredItems[index]['body']),
                );
              },
            ),
          ),
        ],
      ),
           floatingActionButton: FloatingActionButton(
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20),
             ),
             backgroundColor: Colors.black12,
              onPressed: _navigateToConfirmationScreen,
                child: Icon(Icons.add, color: Colors.white,),
           ),
    );
  }
}

// class ConfirmationScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Confirmation'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: Text('Confirmation'),
//                 content: Text('Are you sure you want to proceed?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop(false);
//                     },
//                     child: Text('Cancel'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop(true);
//                     },
//                     child: Text('Yes'),
//                   ),
//                 ],
//               ),
//             ).then((result) {
//               if (result == true) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Proceeding with the action!')),
//                 );
//               }
//             });
//           },
//           child: Text('Show Confirmation Dialog'),
//         ),
//       ),
//     );
//   }
// }