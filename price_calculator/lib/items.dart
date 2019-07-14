
class Items{
  static List<Item> getItems()
  {
    return [
      Item('A1', 'A1', 1000.0, RawMaterials.getRawMaterials(['R1'])),
      Item('B1', 'B1', 2000.0, RawMaterials.getRawMaterials(['R2', 'R4'])),
      Item('C1', 'C1', 3000.0, RawMaterials.getRawMaterials(['R3'])),
      Item('D1', 'D1', 4000.0, RawMaterials.getRawMaterials(['R3', 'R1'])),
    ];
  }
}

class Item{
  String _id;
  String _name;
  double _price;
  List<RawMaterial> _rawMaterials;

  Item(this._id, this._name, this._price, this._rawMaterials);

  String get name => _name;
  double get price => _price;
  String get id => _id;
  List<RawMaterial> get rawMaterials => _rawMaterials;
}

class RawMaterials {
  static List<RawMaterial> getRawMaterials(List<String> ids) {
    var rawMaterials = [
      RawMaterial('R1', 1.0),
      RawMaterial('R2', 3.0),
      RawMaterial('R3', 20.0),
      RawMaterial('R4', 15.0),
    ];
    var res = rawMaterials.where((rm) => ids.contains(rm.name));
    assert(res.length == ids.length, 'Could not find raw material for some ids.');
    return res.toList();
  }
}

class RawMaterial {
  String _name;
  double _price;

  RawMaterial(this._name, this._price);

  String get name => _name;
  double get price => _price;
}
