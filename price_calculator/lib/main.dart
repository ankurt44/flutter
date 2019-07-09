import 'package:flutter/material.dart';
import 'items.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 25.0,
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),
          subtitle: TextStyle(
            fontSize: 15.0,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
          display1: TextStyle(
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
          button: TextStyle(
            fontSize: 25.0,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
        ),
        buttonTheme: ButtonThemeData(
          splashColor: Colors.lightBlueAccent,
        ),
      ),
      home: ItemsSelectionPage(),
    );
  }
}

class ItemsSelectionPage extends StatefulWidget {
  @override
  _ItemsSelectionPageState createState() => _ItemsSelectionPageState();
}

class _ItemsSelectionPageState extends State<ItemsSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Selection'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(
            children: Items.getItems()
                .map((item) => buildTile(item, context))
                .toList(),
          )),
          Container(
            child: Align(
              child: FlatButton(
                child: Text(
                  'Next',
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () => {},
                shape: RoundedRectangleBorder(),
              ),
              alignment: Alignment.bottomCenter,
            ),
          )
        ],
      ),
    );
  }

  Widget buildTile(Item item, BuildContext context) {
    var padding2 = Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid, color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          title: Text(
            item.Name,
            style: Theme.of(context).textTheme.display1,
          ),
          onTap: () => _showDialog(context, item),
        ),
      ),
    );
    return padding2;
  }

  _showDialog(BuildContext context, Item item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Wrap(
              direction: Axis.vertical,
              children: _showItemInfo(item),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close', style: Theme.of(context).textTheme.button),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  List<Widget> _showItemInfo(Item item) {
    var infos = <Widget>[
      Text(item.Name, style: Theme.of(context).textTheme.title,),
      Divider()
    ];
    infos.addAll(item.rawMaterials.map((i) => Text(i.name, style: Theme.of(context).textTheme.subtitle,)));
    return infos;
  }
}
