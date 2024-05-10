import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/graph_ql_service.dart';

class AddPostScreen extends StatefulWidget {
  final String title;
  final String body;
  const AddPostScreen({super.key, required this.title, required this.body});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late PostModel post;
  bool isLoading = true;

  Future<void> addPost({required String title, required String body}) async {
    const query = '''
      mutation (
  \$input: CreatePostInput!
) {
  createPost(input: \$input) {
    id
    title
    body
  }
}
    ''';

    final variables = {
      "input": {"title": title, "body": body}
    };

    final result = await GraphQLService().mutation(query, variables: variables);
    post = PostModel.fromJson(result.data!['createPost']);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    addPost(body: widget.body, title: widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildPostCard(post));
  }

  Widget _buildPostCard(PostModel post) {
    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        Card(
          color: Colors.purple.shade100,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ID: ${post.id}",
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "Title: ${post.title}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  "Body: ${post.body}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
