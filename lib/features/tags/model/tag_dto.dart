import 'package:drift/drift.dart';

import '../../../core/database/local_database.dart';

class TagDto {
  int? id;
  String? uuid;
  String name = '';
  int color = -1;

  TagDto(
      {this.id, required this.uuid, required this.name, required this.color});

  TagDto.fromValue({required this.name, required this.color});

  TagDto.fromData(Tag data)
      : id = data.id,
        uuid = data.uuid,
        name = data.name,
        color = data.color;

  TagsCompanion toCompanion() => TagsCompanion(
        uuid: Value(uuid!),
        name: Value(name),
        color: Value(color),
      );

  Tag toData() => Tag(uuid: uuid!, name: name, color: color, id: id!);

  Map<String, dynamic> toJson() => {'uuid': uuid, 'name': name, 'color': color};

  TagDto.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        name = json['name'],
        color = json['color'];
}
