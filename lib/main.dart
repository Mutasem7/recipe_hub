import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // استيراد مكتبة Provider
import 'package:recipe_hub/database/sql_db.dart';
import 'package:recipe_hub/satemangmint/useridind.dart';
import 'screens/sing_in_screen.dart'; // استيراد شاشة تسجيل الدخول
import 'screens/Home_screen.dart'; // استيراد الشاشة الرئيسية
import 'screens/sign_up.dart'; // استيراد شاشة التسجيل
import 'screens/comment_Showing.dart'; // استيراد شاشة عرض التعليقات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserIDind())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // إخفاء شعار التصحيح (Debug Banner)
      initialRoute: '/', // شاشة تسجيل الدخول كافتراضية
      routes: {
        '/': (context) => const SingInScreen(), // شاشة تسجيل الدخول
        '/home': (context) => const HomeScreen(), // الشاشة الرئيسية
        '/SignUp': (context) => const SignUpScreen(), // شاشة التسجيل
        '/comments':
            (context) => CommentShowing(
              recipeId: ModalRoute.of(context)!.settings.arguments as int,
            ), // شاشة عرض التعليقات
      },
    );
  }
}
