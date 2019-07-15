import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'items.dart';

class DiscountSelector extends StatelessWidget {
  final List<Item> _items;
  final Map<String, int> _counts;

  DiscountSelector(this._items, this._counts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildPage(context),
        ),
      ),
    );
  }

  List<Widget> _buildPage(BuildContext context) {
    var widgets = _items.map((item) => _buildTile(item, context)).toList();
    
    var totalPrice = 0.0;
    _items.forEach((i) => totalPrice += (_counts[i.name] * i.price));

    widgets.addAll(<Widget>[
      SizedBox(
        height: 5.0,
      ),
      _DiscountSelector(totalPrice),
    ]);

    return widgets;
  }

  Widget _buildTile(Item item, BuildContext context) {
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
          trailing: Text(_counts[item.name].toString()),
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
            children: _showItemInfo(context, item),
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

  List<Widget> _showItemInfo(BuildContext context, Item item) {
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

class _DiscountSelector extends StatefulWidget {
  final double _totalPrice;

  _DiscountSelector(this._totalPrice);

  @override
  __DiscountSelectorState createState() => __DiscountSelectorState();
}

class __DiscountSelectorState extends State<_DiscountSelector> {
  int _discount = 0;

  @override
  Widget build(BuildContext context) {

    var discountedPrice = widget._totalPrice * (100 - _discount) / 100;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid, color: Colors.grey),
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Slider(
              min: 0,
              max: 100,
              onChanged: (val) {
                setState(() => _discount = val.round());
              },
              value: _discount.toDouble(),
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Discount',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Text(
                      _discount.toString(),
                      style: Theme.of(context).textTheme.title,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Price',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Text(
                      discountedPrice.toString(),
                      style: Theme.of(context).textTheme.title,
                    ),
                  ],
                ),
                FlatButton(child: Text('Send Email'), 
                  onPressed: () { sendEmail(); },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future sendEmail() async {
    await FlutterMailer.send(mailOptions);
  }

}

final MailOptions mailOptions = MailOptions(
  body: 'a long body for the email <br> with a subset of HTML',
  subject: 'the Email Subject',
  recipients: ['ankurtiwari044@gmail.com'],
  isHTML: true,
  bccRecipients: [''],
  ccRecipients: [''],
  //attachments: [],
);
