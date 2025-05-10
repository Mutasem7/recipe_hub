class UserTable {
  static String get users => 'users';

  static String get id => 'id';
  static String get username => 'username';
  static String get password => 'password';

  static String get create => '''
      CREATE TABLE IF NOT EXISTS `$users` (
            `$id` INTEGER PRIMARY KEY AUTOINCREMENT,
            `$username` TEXT NOT NULL,
            `$password` TEXT NOT NULL
       )''';
}
