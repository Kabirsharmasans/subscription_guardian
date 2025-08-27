import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  Category({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'Category{id: $id, name: $name}';
  }
}