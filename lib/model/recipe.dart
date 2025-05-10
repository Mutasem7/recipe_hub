class Recipe {
  int? id; // تغيير نوع id إلى String
  final int userID;
  final String title;
  final String backgroundImage;
  final String description;
  final int persons;
  final int rate;
  final int view;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
    this.id,
    required this.userID,
    required this.title,
    required this.backgroundImage,
    required this.description,
    required this.persons,
    required this.rate,
    required this.view,
    required this.createdAt,
    required this.updatedAt,
  });

  // تحويل JSON إلى كائن Recipe
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'], // id من نوع String
      userID: json['userID'],
      title: json['title'],
      backgroundImage: json['backgroundImage'],
      description: json['description'],
      persons: json['persons'],
      rate: json['rate'],
      view: json['view'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // تحويل كائن Recipe إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'title': title,
      'backgroundImage': backgroundImage,
      'description': description,
      'persons': persons,
      'rate': rate,
      'view': view,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
