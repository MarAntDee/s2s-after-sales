import 'package:surf2sawa/utils/dev-tools.dart';

class Outage with MappedModel {
  final String title, description;
  final bool hasOutage;

  Outage._(this.title, this.description, this.hasOutage);

  factory Outage.fromMap(Map map) => Outage._(
    map['title'],
    map['description'],
    map['status'],
  );
}