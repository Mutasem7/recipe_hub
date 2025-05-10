import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_hub/model/comment.dart';
import 'package:recipe_hub/providers/comment/comment_provider.dart';
import 'package:recipe_hub/providers/user/user_provider.dart';
import 'package:recipe_hub/satemangmint/useridind.dart';

class CommentShowing extends StatelessWidget {
  final int recipeId; // معرف الوصفة
  CommentShowing({super.key, required this.recipeId});

  final userProvider = UserProvider();
  final TextEditingController _commentController =
      TextEditingController(); // للتحكم في النص المدخل

  @override
  Widget build(BuildContext context) {
    final commentProvider = CommentProvider();
    final commentsFuture = commentProvider.getComments(recipeId);

    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          // قائمة التعليقات
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading comments'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No comments yet'));
                } else {
                  final comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: ListTile(
                          title: FutureBuilder<String>(
                            future: userProvider.getusername(
                              context.watch<UserIDind>().userID,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('Loading...');
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                              } else {
                                return Text(snapshot.data ?? 'Unknown');
                              }
                            },
                          ),
                          subtitle: Text(comment.description),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // إدخال تعليق جديد
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController, // ربط الحقل بالمتحكم
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final value = _commentController.text.trim();
                    if (value.isNotEmpty) {
                      final newComment = Comment(
                        id: 0,
                        recipeID: recipeId,
                        userID: 1,
                        description: value, // تخزين النص في description
                      );
                      commentProvider.addComment(newComment); // إضافة التعليق
                      _commentController.clear(); // مسح النص بعد الإرسال
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
