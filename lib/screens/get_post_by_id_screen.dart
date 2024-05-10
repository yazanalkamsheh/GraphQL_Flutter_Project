import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/graph_ql_service.dart';

class GetPostByIDScreen extends StatefulWidget {
  const GetPostByIDScreen({super.key});

  @override
  State<GetPostByIDScreen> createState() => _GetPostByIDScreenState();
}

class _GetPostByIDScreenState extends State<GetPostByIDScreen> {
  late PostModel post;
  bool isLoading = true;

  Future<void> getAllPosts() async {
    const query = '''
      query {
  post(id: 1) {
    id
    title
    body
  }
}
    ''';

    final result = await GraphQLService().query(query);
    post =  PostModel.fromJson(result.data!['post']);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getAllPosts();
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
