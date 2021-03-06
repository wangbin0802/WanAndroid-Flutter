import 'package:json_annotation/json_annotation.dart';

part 'system_category.g.dart';

@JsonSerializable()
class SystemCategory extends Object {
  @JsonKey(name: 'children')
  List<SystemCategory> children;

  @JsonKey(name: 'courseId')
  int courseId;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'order')
  int order;

  @JsonKey(name: 'parentChapterId')
  int parentChapterId;

  @JsonKey(name: 'userControlSetTop')
  bool userControlSetTop;

  @JsonKey(name: 'visible')
  int visible;

  SystemCategory(
    this.children,
    this.courseId,
    this.id,
    this.name,
    this.order,
    this.parentChapterId,
    this.userControlSetTop,
    this.visible,
  );

  factory SystemCategory.fromJson(Map<String, dynamic> srcJson) =>
      _$SystemCategoryFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SystemCategoryToJson(this);
}
