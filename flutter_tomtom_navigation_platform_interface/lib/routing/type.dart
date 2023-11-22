import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'type')
enum Type {
  bookmarkHome(0),
  bookmarkWork(1),
  bookmarkFavorite(2),
  recent(3);

  const Type(this.type);

  final int type;
}
