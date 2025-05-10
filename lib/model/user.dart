import 'package:recipe_hub/tables/user_table.dart';

class UserModel {
  int? id;
  final String name;
  final String password;

  UserModel({this.id, required this.name, required this.password});

  factory UserModel.fromMap(Map<dynamic, dynamic> map) => UserModel(
    id: map[UserTable.id],
    name: map[UserTable.username],
    password: map[UserTable.password],
  );
  Map<String, Object?> toMap() => {
    if (id != null) UserTable.id: id,
    UserTable.username: name,
    UserTable.password: password,
  };
}
