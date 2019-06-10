import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeFinder',
      theme: ThemeData(primaryColor: Colors.white),
      home: _AddItemsWidget(),
    );
  }
}

class _AddItemsWidget extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _AddItemsWidgetState();
  
}

class _AddItemsWidgetState extends State<_AddItemsWidget>
{
  final _items = <String>[];
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add items'),),
      body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(controller: _textFieldController,),
                ), 
                IconButton(
                  icon: Icon(Icons.add_circle), 
                  onPressed: () {
                    setState(() {
                      String item = _textFieldController.text;
                      if(item.isNotEmpty){
                        _items.add(item);
                        _textFieldController.clear();
                      }
                    });
                  },
                  tooltip: 'Click to add item',
                ),
              ],
            ),
            _buildItemsList(), // Item list
            ButtonTheme(
              minWidth: double.infinity,
              height: 50.0,
              child: FlatButton(
                child: Text('Search Recipes'),
                onPressed: (){
                  _showRecipes();
                }, 
                disabledColor: Colors.grey,
                color: Colors.blue,
              ),
            )
          ],
        ),
    );
  }

  Widget _buildItemsList()
  {
    final Iterable<ListTile> tiles = _items.map(
      (String item){
        return ListTile(
          title: Text(item,),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              setState(() {
               _items.remove(item); 
              });
            },
          ),
        );
      },
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles
    ).toList();
    return Expanded(child: ListView(children: divided));
  }

  void _showRecipes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return Scaffold(
            appBar: AppBar(title: Text('Recipes'),),
            body: _downloadRecipes(),
          );
        }
      )
    );
  }

  Widget _downloadRecipes() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('recipes').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildRecipesListView(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildRecipesListView(BuildContext context, List<DocumentSnapshot> documents) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0),
      children: documents.map((data) => _buildRecipeListItem(context, data)).toList(),
    );
  }

  Widget _buildRecipeListItem(BuildContext context, DocumentSnapshot data) {
    final _recipe = _Recipe.fromSnapshot(data);

    return Padding(
      key: ValueKey(_recipe.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(_recipe.name),
          trailing: Text(_recipe.rating.toString() + '/5'),
        ),
      ),
    );
  }
}

class _Recipe {
  final String _name;
  final String _description;
  final int _rating;
  final DocumentReference ref;

  _Recipe.fromMap(Map<String, dynamic> map, {this.ref}) 
    : assert(map['name'] != null),
    assert(map['description'] != null),
    assert(map['rating'] != null),
    assert(map['ingredients'] != null),
    _name = map['name'],
    _description = map['description'],
    _rating = map['rating'];

  _Recipe.fromSnapshot(DocumentSnapshot document)
    : this.fromMap(document.data, ref: document.reference);

  String get name => _name;
  String get description => _description;
  int get rating => _rating;
}