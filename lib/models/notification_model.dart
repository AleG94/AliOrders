class Notification {
  Notification({this.id, this.type, this.orderClosesOn, this.orderId});

  int id;
  int type;
  int orderId;
  DateTime orderClosesOn;

  static Notification fromMap(Map<String, dynamic> data) {
    return Notification(
      id: data['id'] as int,
      type: data['type'] as int,
      orderId: data['order_id'] as int,
      orderClosesOn: DateTime.fromMillisecondsSinceEpoch((data['order_closes_on'] as int) * 1000),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'order_id': orderId,
      'order_closes_on': (orderClosesOn.millisecondsSinceEpoch / 1000).round(),
    };
  }
}
