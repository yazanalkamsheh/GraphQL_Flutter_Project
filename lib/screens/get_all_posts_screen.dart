import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/graph_ql_service.dart';

class AllPostsScreen extends StatefulWidget {
  const AllPostsScreen({super.key});

  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  late List<PostModel> postList;
  bool isLoading = true;

  Future<void> getAllPosts() async {
    const query = '''
      query (
  \$options: PageQueryOptions
) {
  posts(options: \$options) {
    data {
      id
      title
    }
    meta {
      totalCount
    }
  }
}
    ''';

    final result = await GraphQLService().query(query);
    postList = (result.data!['posts']['data'] as List)
        .map((post) => PostModel.fromJson(post))
        .toList();
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
          : ListView.separated(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 40,vertical: 16),
              itemBuilder: (context, index) => _buildPostCard(postList[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: postList.length,
            ),
    );
  }

  Widget _buildPostCard(PostModel post) {
    return Card(
      color: Colors.purple.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID: ${post.id}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Title: ${post.title}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
