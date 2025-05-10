import 'package:recipe_hub/database/sql_db.dart';
import 'package:recipe_hub/model/user.dart';
import 'package:recipe_hub/tables/user_table.dart';

class UserProvider {
  Future<String> getusername(int userId) async {
    var db = await SqfliteDatabase.getDb();
    List<Map> maps = await db.query(
      UserTable.users,
      where: '${UserTable.id} = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      final user = UserModel.fromMap(maps.first);
      return user.name; // Assuming 'username' is a field in UserModel
    }
    return "null";
  }

  Future<UserModel> addUser(UserModel user) async {
    var db = await SqfliteDatabase.getDb();
    user.id = await db.insert(UserTable.users, user.toMap());
    return user;
  }

  Future<UserModel?> getUser(String username) async {
    var db = await SqfliteDatabase.getDb();
    List<Map> maps = await db.query(
      UserTable.users,
      where: '${UserTable.username} = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (maps.isNotEmpty) return UserModel.fromMap(maps.first);
    return null;
  }
}
