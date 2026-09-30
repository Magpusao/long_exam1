import 'package:flutter/material.dart';

import '../models/post.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likes = widget.post.likes;
  bool _isLiked = false;

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id) {
      _likes = widget.post.likes;
      _isLiked = false;
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.post.body),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    tooltip: _isLiked ? 'Unlike' : 'Like',
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: _isLiked
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  Text('$_likes'),
                  const SizedBox(width: 16),
                  const Icon(Icons.thumb_down_outlined, size: 20),
                  const SizedBox(width: 6),
                  Text('${widget.post.dislikes}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
