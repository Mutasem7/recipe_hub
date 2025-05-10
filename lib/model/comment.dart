class Comment {
  int? id;
  final int recipeID;
  final int userID;
  final String description;
  int? supCommentID;
  int? rate;
  DateTime? createdAt;
  DateTime? updatedAt;

  Comment({
    this.id,
    required this.recipeID,
    required this.userID,
    required this.description,
    this.supCommentID,
    this.rate,
    this.createdAt,
    this.updatedAt,
  });

  // تحويل JSON إلى كائن Comment
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      recipeID: json['recipeID'],
      userID: json['userID'],
      description: json['description'],
      supCommentID: json['supCommentID'],
      rate: json['rate'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // تحويل كائن Comment إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipeID': recipeID,
      'userID': userID,
      'description': description,
      'supCommentID': supCommentID,
      'rate': rate,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
