import 'package:flutter/material.dart';

void main() => runApp(MyJsonApp());

class MyJsonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeApp',
      theme: ThemeData(primaryColor: Colors.white),
      home: _AddItems()
    );
  }
}

class _AddItemsState extends State<_AddItems>
{
  final _items = <String>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final _textFieldController = TextEditingController();

  Widget _buildItemsList() {
    final Iterable<ListTile> tiles = _items.map(
      (String item){
        return ListTile(
          title: Text(item, style: _biggerFont,),
        );
      },
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles
    ).toList();
    return Expanded(child: ListView(children: divided));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Items')),
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
            _buildItemsList(),
          ],
        ),
    );
  }
}

class _AddItems extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddItemsState();
}
