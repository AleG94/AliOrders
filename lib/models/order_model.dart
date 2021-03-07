class Order {
  Order({this.id, this.name, this.shippedOn, this.closesOn});

  int id;
  String name;
  DateTime shippedOn;
  DateTime closesOn;

  static Order fromMap(Map<String, dynamic> data) {
    return Order(
      id: data['id'] as int,
      name: data['name'] as String,
      shippedOn: DateTime.fromMillisecondsSinceEpoch((data['shipped_on'] as int) * 1000),
      closesOn: DateTime.fromMillisecondsSinceEpoch((data['closes_on'] as int) * 1000),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'shipped_on': (shippedOn.millisecondsSinceEpoch / 1000).round(),
      'closes_on': (closesOn.millisecondsSinceEpoch / 1000).round(),
    };
  }
}
