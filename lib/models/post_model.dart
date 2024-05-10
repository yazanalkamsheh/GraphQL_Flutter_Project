import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final String id;
  final String title;
  final String body;

  const PostModel({required this.id, required this.title, required this.body});

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'],
        title: json['title'],
        body: json['body'] ?? "",
      );

  @override
  List<Object?> get props => [id, title, body];
}
