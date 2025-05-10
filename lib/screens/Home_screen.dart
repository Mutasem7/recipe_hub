import 'dart:convert'; // لإجراء فك ترميز Base64
import 'package:flutter/material.dart';
import 'package:recipe_hub/providers/recipe/recipe_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final rp = RecipeProvider();
  late Future<List<dynamic>> _recipesFuture;

  // قائمة لتتبع الوصفات المفضلة
  final Set<int> _favoriteRecipes = {};

  @override
  void initState() {
    super.initState();
    _recipesFuture = rp.fetchRecipes();
  }

  Future<void> _refreshRecipes() async {
    setState(() {
      _recipesFuture = rp.fetchRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshRecipes, // استدعاء التحديث عند النقر
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: RefreshIndicator(
          onRefresh: _refreshRecipes,
          color: Colors.white, // تغيير لون دائرة التحديث إلى الأبيض
          child: FutureBuilder<List<dynamic>>(
            future: _recipesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // أثناء تحميل البيانات
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // إذا حدث خطأ أثناء جلب البيانات
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // إذا كانت البيانات فارغة
                return const Center(
                  child: Text(
                    'No recipes found.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                // إذا تم جلب البيانات بنجاح
                final recipes = snapshot.data!;
                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    final recipeId = recipe['id'];

                    return Card(
                      color: const Color.fromARGB(255, 122, 119, 119),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // عرض الصورة
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10.0),
                            ),
                            child:
                                recipe['backgroundImage'] != null
                                    ? Image.memory(
                                      base64Decode(recipe['backgroundImage']),
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.network(
                                      'https://via.placeholder.com/150',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // عنوان الوصفة
                                Text(
                                  recipe['title'] ?? 'No Name',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // وصف الوصفة
                                Text(
                                  recipe['description'] ?? 'No Description',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // زر IconButton
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _favoriteRecipes.contains(recipeId)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                color:
                                    _favoriteRecipes.contains(recipeId)
                                        ? Colors.red
                                        : Colors.white,
                                onPressed: () {
                                  setState(() {
                                    if (_favoriteRecipes.contains(recipeId)) {
                                      _favoriteRecipes.remove(recipeId);
                                    } else {
                                      _favoriteRecipes.add(recipeId);
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.message_rounded,
                                  color: Colors.white, // لون الأيقونة
                                ),
                                onPressed: () {
                                  // تنفيذ إجراء عند النقر على الزر
                                  Navigator.pushNamed(
                                    context,
                                    '/comments',
                                    arguments: recipe['id'], // تمرير recipeId
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
