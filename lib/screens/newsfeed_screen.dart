import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
import 'detail_screen.dart';

class NewsfeedScreen extends StatefulWidget {
  final User user;

  const NewsfeedScreen({super.key, required this.user});

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  late final Future<List<Post>> _posts = PostService().getPosts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Newsfeed')),
      body: FutureBuilder<List<Post>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Unable to load posts: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              return PostCard(
                post: post,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailScreen(post: post, currentUser: widget.user),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
