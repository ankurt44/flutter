import 'package:flutter/material.dart';

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
    var recipes = _downloadRecipes();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return RecipesWidget(recipes);
        }
      )
    );
  }

  Iterable<_Recipe> _downloadRecipes() {
    final Set<_Recipe> _saved = {};
    return _saved;
  }
}

class RecipesWidget extends StatelessWidget {

  Set<_Recipe> _recipes;

  RecipesWidget( recipes) {
    _recipes = recipes;
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = _recipes.map(
        (_Recipe a){
          return ListTile(
            title: Text(
              a.name, 
            ),
          );
        },
      );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles
    )
    .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: ListView(children: divided,)
    );
  }
}

class _Recipe {
  String _name;
  String _description;
  int _rating;

  _Recipe(String name, String description, int rating) {
    _name = name;
    _description = description;
    _rating = rating;
  }

  String get name => _name;
  String get description => _description;
  int get rating => _rating;
}