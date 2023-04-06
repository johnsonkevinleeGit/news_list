import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Story.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Story(
        id: data?['name'],
        by: data?['state'],
        descendants: data?['descendants'],
        kids: data?['kids'] is Iterable ? List<int>.from(data?['kids']) : null,
        score: data?['score'],
        time: data?['time'],
        title: data?['title'],
        type: data?['type'],
        url: data?['url']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (by != null) "by": by,
      if (descendants != null) "descendants": descendants,
      if (kids != null) "kids": kids,
      if (score != null) "score": score,
      if (time != null) "time": time,
      if (title != null) "title": title,
      if (type != null) "type": type,
      if (url != null) "url": url,
    };
  }
}
