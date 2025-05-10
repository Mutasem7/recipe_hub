import 'package:recipe_hub/api/ApiService.dart';
import 'package:recipe_hub/api/endpoint.dart';
import 'package:recipe_hub/model/comment.dart';

class CommentProvider {
  final _api = ApiService.instance; // استبدل هذا بالمسار الصحيح
  final String _endpoint =
      Endpoint.get_all_commnet; // استبدل هذا بالمسار الصحيح
  final String _addCommentEndpoint =
      Endpoint.add_comment; // استبدل هذا بالمسار الصحيح
  Future<List<Comment>> getComments(int recipeId) async {
    final response = await _api.get('$_endpoint/$recipeId');
    if (response.success) {
      return (response.body as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(); // تأكد من أن هذا هو الهيكل الصحيح للبيانات
    } else {
      throw Exception('Failed to load comments: ${response.message}');
    }
  }

  Future<void> addComment(Comment comment) async {
    final response = await _api.post(_addCommentEndpoint, comment.toJson());
    if (!response.success) {
      throw Exception('Failed to add comment: ${response.message}');
    }
  }
}
