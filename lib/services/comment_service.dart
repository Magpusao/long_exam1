import 'dart:convert';

import 'package:http/http.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/user.dart';
import 'comment_database.dart';

class CommentService {
  CommentService({CommentDatabase? database})
    : _database = database ?? CommentDatabase.instance;

  final CommentDatabase _database;

  Future<List<Comment>> getComments(int postId) async {
    final localComments = await _database.getCommentsForPost(postId);

    try {
      final response = await get(Uri.parse('$host/comments/post/$postId'));
      if (response.statusCode != 200) {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      final List comments = data['comments'] ?? [];
      final remoteComments = comments
          .map((item) => Comment.fromJson(item))
          .toList();
      return [...localComments, ...remoteComments];
    } catch (_) {
      // Saved comments should remain available even when the remote feed is
      // temporarily unreachable.
      if (localComments.isNotEmpty) return localComments;
      rethrow;
    }
  }

  Future<Comment> addComment({
    required String body,
    required int postId,
    required User author,
  }) async {
    return _database.insertComment(body: body, postId: postId, author: author);
  }
}
