import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@JsonSerializable()
class Story {
  const Story(
      {this.id,
      this.by,
      this.descendants,
      this.kids,
      this.score,
      this.time,
      this.title,
      this.type,
      this.url});
  final int? id;
  final String? by;
  final int? descendants;
  final List<int>? kids;
  final int? score;
  final int? time;
  final String? title;
  final String? type;
  final String? url;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
