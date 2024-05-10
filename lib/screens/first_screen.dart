import 'package:flutter/material.dart';
import 'package:task_graph_ql/screens/add_post_screen.dart';
import 'package:task_graph_ql/screens/get_all_posts_pagination_screen.dart';
import 'package:task_graph_ql/screens/get_post_by_id_screen.dart';
import 'get_all_posts_screen.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Graph QL Query Test",
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineMedium),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const AllPostsScreen()),
              child: Text(
                "Get All Post",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  _navigateTo(context, const AllPostsPaginationScreen()),
              child: Text(
                "Get All Post Pagination",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showPostsFieldDialog(context),
              child: Text(
                "Add Post",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const GetPostByIDScreen()),
              child: Text(
                "Get Post By ID 1",
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _navigateTo(BuildContext context, Widget screen) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));

  _showPostsFieldDialog(BuildContext context) =>
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          enableDrag: false,
          builder: (context) {
            return Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom),
                child: Container(
                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text("Add Post", style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall,),
                      const SizedBox(height: 40),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            validator: (val) {
                              if (val != null && val.isNotEmpty) return null;
                              return "Field must be not empty";
                            },
                            autofocus: true,
                            decoration: const InputDecoration(
                                label: Text('Title'),
                                border: OutlineInputBorder()
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: bodyController,
                            validator: (val) {
                              if (val != null && val.isNotEmpty) return null;
                              return "Field must be not empty";
                            },
                            autofocus: true,
                            decoration: const InputDecoration(
                                label: Text('Body'),
                                border: OutlineInputBorder()
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                            vertical: 16),
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red)
                              ),
                              child: const Text("Cancel"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.of(context).pop();
                                  _navigateTo(context, AddPostScreen(
                                      title: titleController.text,
                                      body: bodyController.text));
                                }
                              },
                              child: const Text("Done"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
}
