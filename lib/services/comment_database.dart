import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/comment.dart';
import '../models/user.dart';

/// Stores comments created in this app.
///
/// DummyJSON's comment creation endpoint is simulated and does not persist
/// writes, so user-created comments are kept in SQLite on the device instead.
class CommentDatabase {
  CommentDatabase._();

  static final CommentDatabase instance = CommentDatabase._();

  static const _databaseName = 'long_exam.db';
  static const _databaseVersion = 1;
  static const _commentsTable = 'comments';

  Future<Database>? _databaseFuture;

  Future<Database> get database => _databaseFuture ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    return openDatabase(
      path.join(databasePath, _databaseName),
      version: _databaseVersion,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE $_commentsTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER NOT NULL,
            user_id INTEGER NOT NULL,
            body TEXT NOT NULL,
            likes INTEGER NOT NULL DEFAULT 0,
            username TEXT NOT NULL DEFAULT '',
            full_name TEXT NOT NULL DEFAULT '',
            created_at TEXT NOT NULL
          )
        ''');
        await database.execute('''
          CREATE INDEX index_comments_post_created
          ON $_commentsTable (post_id, created_at DESC)
        ''');
        await database.execute('''
          CREATE INDEX index_comments_user
          ON $_commentsTable (user_id)
        ''');
      },
    );
  }

  Future<List<Comment>> getCommentsForPost(int postId) async {
    final db = await database;
    final rows = await db.query(
      _commentsTable,
      where: 'post_id = ?',
      whereArgs: [postId],
      orderBy: 'created_at DESC, id DESC',
    );

    return rows.map(_commentFromRow).toList(growable: false);
  }

  Future<Comment> insertComment({
    required String body,
    required int postId,
    required User author,
  }) async {
    if (author.id <= 0) {
      throw ArgumentError.value(author.id, 'author.id', 'Must be positive.');
    }

    final db = await database;
    final id = await db.insert(_commentsTable, {
      'post_id': postId,
      'user_id': author.id,
      'body': body,
      'likes': 0,
      'username': author.username,
      'full_name': author.fullName,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    return Comment(
      id: id,
      body: body,
      postId: postId,
      userId: author.id,
      likes: 0,
      username: author.username,
      fullName: author.fullName,
    );
  }

  Comment _commentFromRow(Map<String, Object?> row) {
    return Comment(
      id: row['id'] as int,
      body: row['body'] as String,
      postId: row['post_id'] as int,
      userId: row['user_id'] as int,
      likes: row['likes'] as int,
      username: row['username'] as String,
      fullName: row['full_name'] as String,
    );
  }
}
