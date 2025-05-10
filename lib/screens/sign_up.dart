import 'dart:io'; // مهم لقراءة ملفات الصور من الجهاز
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipe_hub/model/user.dart';
import 'package:recipe_hub/providers/user/user_provider.dart';
import 'package:recipe_hub/satemangmint/useridind.dart';
import '../providers/validator/auth_validator.dart';
import '../providers/util/image_picker_helper.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _profileImagePath;
  final up = UserProvider();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _pickImage() async {
    final String? imagePath = await ImagePickerHelper.pickImageFromGallery();
    if (imagePath != null) {
      setState(() {
        _profileImagePath = imagePath;
      });
    }
  }

  Future<void> _send(
    String username,
    String password,
    String? profileImagePath,
  ) async {
    var user = UserModel(name: username, password: password);
    var updateduser = await up.addUser(user);
    print(updateduser.toMap());
    if (updateduser.id != null) {
      context.read<UserIDind>().setUserID(updateduser.id!);
    } else {
      throw Exception('User ID is null');
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية كصورة
          Positioned.fill(
            child: Image.asset('images/SingIn.jpg', fit: BoxFit.cover),
          ),
          // المحتوى فوق الصورة
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // رفع صورة
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  _profileImagePath != null
                                      ? FileImage(File(_profileImagePath!))
                                      : null,
                              child:
                                  _profileImagePath == null
                                      ? const Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // حقل اسم المستخدم
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: AuthValidator.validateUsername,
                          ),
                          const SizedBox(height: 20),

                          // حقل البريد الإلكتروني
                          // TextFormField(
                          //   controller: _emailController,
                          //   keyboardType: TextInputType.emailAddress,
                          //   decoration: InputDecoration(
                          //     labelText: 'Email',
                          //     labelStyle: const TextStyle(color: Colors.white),
                          //     filled: true,
                          //     fillColor: Colors.black.withOpacity(0.5),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   style: const TextStyle(color: Colors.white),
                          //   validator: AuthValidator.validateEmail,
                          // ),
                          // const SizedBox(height: 20),

                          // حقل رقم الجوال باستخدام intl_phone_field
                          IntlPhoneField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            initialCountryCode: 'YE', // رمز الدولة الافتراضي
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                            validator:
                                (value) => AuthValidator.validatePhoneNumber(
                                  value?.completeNumber,
                                ),
                          ),
                          const SizedBox(height: 20),

                          // كلمة المرور
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: AuthValidator.validatePassword,
                          ),
                          const SizedBox(height: 20),

                          // تأكيد كلمة المرور
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.black.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator:
                                (value) =>
                                    AuthValidator.validateConfirmPassword(
                                      _passwordController.text,
                                      value,
                                    ),
                          ),
                          const SizedBox(height: 30),

                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final username =
                                    _usernameController.text.trim();
                                final password =
                                    _passwordController.text.trim();

                                final profileImagePath = _profileImagePath;

                                _send(username, password, profileImagePath);
                              }
                            },
                            child: const Text('Sign Up'),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Already have an account? Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
