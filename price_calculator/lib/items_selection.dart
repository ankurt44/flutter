import 'package:flutter/material.dart';
import 'items.dart';
import 'discount_selector.dart';

class ItemsSelectionPage extends StatefulWidget {
  final List<Item> _items;

  ItemsSelectionPage(this._items);

  @override
  _ItemsSelectionPageState createState() => _ItemsSelectionPageState();
}

class _ItemsSelectionPageState extends State<ItemsSelectionPage> {
  Map<String, int> _counts;

  @override
  void initState() {
    super.initState();
    var counts = widget._items.map((i) => 0);
    var keys = widget._items.map((i) => i.name);
    _counts = Map.fromIterables(keys, counts);
  }
  
  @override
  Widget build(BuildContext context) {
    var items = Items.getItems();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: items.map((item) => buildTile(item, context)).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiscountSelector(items, _counts),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
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
            item.name,
            style: Theme.of(context).textTheme.display1,
          ),
          onTap: () => _showDialog(context, item),
          trailing: Wrap(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.exposure_neg_1),
                onPressed: () {
                  if (_counts[item.name] > 0) {
                    setState(() {
                      _counts[item.name]--;
                    });
                  }
                },
              ),
              Container(
                child: Text(
                  _counts[item.name].toString(),
                ),
                width: 15.0,
              ),
              IconButton(
                icon: Icon(Icons.exposure_plus_1),
                onPressed: () {
                  setState(() {
                    _counts[item.name]++;
                  });
                },
              ),
            ],
          ),
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
              child: Text(
                'Close',
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _showItemInfo(Item item) {
    var infos = <Widget>[
      Text(
        item.name,
        style: Theme.of(context).textTheme.title,
      ),
      Divider(
        color: Colors.black,
      ),
    ];

    infos.addAll(item.rawMaterials.map((i) {
      var txtTheme = Theme.of(context).textTheme.subtitle;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            i.name,
            style: txtTheme,
          ),
          SizedBox(
            width: 50.0,
          ),
          Text(
            item.price.toString(),
            style: txtTheme,
          ),
        ],
      );
    }));
    return infos;
  }
}
