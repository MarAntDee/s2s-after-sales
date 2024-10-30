import '../utils/dev-tools.dart';

class Announcement with MappedModel {
  final String title, message;

  Announcement._({
    required this.title,
    required this.message,
  });

  Announcement.fromMap(Map map) : this._(
    title: map['title'].toString(),
    message: map['message'].toString(),
  );
}