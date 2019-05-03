import 'package:codable/codable.dart';

class Vallis extends Coding {
  String id;
  DateTime expiry;
  bool isWarm;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);

    id = object.decode('id');
    isWarm = object.decode('isWarm');
    expiry = DateTime.parse(object.decode('expiry'));

    if (expiry.difference(DateTime.now().toUtc()) <=
        const Duration(seconds: 1)) {
      isWarm = !isWarm;
      if (isWarm)
        expiry = expiry.add(const Duration(minutes: 6, seconds: 40));
      else
        expiry = expiry.add(const Duration(minutes: 20));
    }
  }

  @override
  void encode(KeyedArchive object) {
    object.encode('expiry', expiry.toIso8601String());
    object.encode('isWarm', isWarm);
  }
}
