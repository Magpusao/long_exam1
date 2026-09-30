import 'package:flutter/material.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/comment_service.dart';
import '../widgets/post_card.dart';

class DetailScreen extends StatefulWidget {
  final Post post;
  final User currentUser;

  const DetailScreen({
    super.key,
    required this.post,
    required this.currentUser,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _commentController = TextEditingController();
  final _commentService = CommentService();
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isAdding = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    try {
      final comments = await _commentService.getComments(widget.post.id);
      if (mounted) setState(() => _comments = comments);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addComment() async {
    final body = _commentController.text.trim();
    if (body.isEmpty || _isAdding) return;

    setState(() => _isAdding = true);
    try {
      final comment = await _commentService.addComment(
        body: body,
        postId: widget.post.id,
        author: widget.currentUser,
      );
      if (!mounted) return;
      setState(() {
        _comments.insert(0, comment);
        _commentController.clear();
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          PostCard(post: widget.post),
          const SizedBox(height: 12),
          Text('Comments', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Post comment',
                onPressed: _isAdding ? null : _addComment,
                icon: _isAdding
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Text(_error!, textAlign: TextAlign.center)
          else if (_comments.isEmpty)
            const Text('No comments yet.', textAlign: TextAlign.center)
          else
            ..._comments.map(
              (comment) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(
                  comment.fullName.isEmpty
                      ? 'User ${comment.userId}'
                      : comment.fullName,
                ),
                subtitle: Text(comment.body),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('${comment.likes}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
