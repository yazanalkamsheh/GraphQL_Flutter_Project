import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/graph_ql_service.dart';

class AllPostsPaginationScreen extends StatefulWidget {
  const AllPostsPaginationScreen({super.key});

  @override
  State<AllPostsPaginationScreen> createState() => _AllPostsPaginationScreenState();
}

class _AllPostsPaginationScreenState extends State<AllPostsPaginationScreen> {
  late List<PostModel> postList;
  late int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    postList = [];
    getAllPostsPagination();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> getAllPostsPagination() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await GraphQLService().query('''
        query (\$options: PageQueryOptions) {
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
      ''', variables: {'options': {'paginate': {'page': currentPage, 'limit': 10}}});

      final List<PostModel> newList = (result.data!['posts']['data'] as List)
          .map((post) => PostModel.fromJson(post))
          .toList();

      setState(() {
        postList.addAll(newList);
        currentPage++;
        isLoading = false;
        hasMore = postList.length < result.data!['posts']['meta']['totalCount'];
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching posts: $e');
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && hasMore && !isLoading) {
      getAllPostsPagination();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading && postList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemBuilder: (context, index) {
          if (index < postList.length) {
            return _buildPostCard(postList[index]);
          } else if (hasMore) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox();
          }
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: postList.length + (hasMore ? 1 : 0),
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
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
