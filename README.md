# Long Exam 1

A Flutter newsfeed app backed by DummyJSON for authentication/posts and a
device-local SQLite database for persistent user comments.

## Persistent comments

DummyJSON's `POST /comments/add` endpoint only simulates a successful write, so
comments sent to it disappear when the screen or session is reloaded. The app
therefore stores submitted comments in `long_exam.db` using `sqflite`.

The implementation works as follows:

1. Authentication restores the complete signed-in `User`, including its
   stable account `id`, from `SharedPreferences`.
2. `HomeScreen` passes that `User` to every `DetailScreen`.
3. Submitting a comment calls `CommentService.addComment`, which inserts the
   text, `post_id`, `user_id`, and author snapshot into SQLite.
4. Opening a post queries SQLite by `post_id` and merges those saved rows with
   the read-only comments returned by DummyJSON.
5. Signing out removes only the authentication session. It does not delete the
   comments database, so signing back into the same account displays the saved
   comments with the original account ID and author name.

The database adds indexes for post/date lookups and account-ID lookups. Saved
comments are also available if the remote comment feed is temporarily offline.

## Run and verify

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

To verify persistence manually, sign in, open a post, submit a comment, sign
out from Settings, sign back in, and reopen the same post. The saved comment
will appear at the top of the list.
