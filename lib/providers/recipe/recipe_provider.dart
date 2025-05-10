import 'package:recipe_hub/api/ApiService.dart';
import 'package:recipe_hub/api/endpoint.dart';

class RecipeProvider {
  final _api = ApiService.instance; // استبدل هذا بالمسار الصحيح
  final String _endpoint = Endpoint.get_recipe; // استبدل هذا بالمسار الصحيح

  Future<List<dynamic>> fetchRecipes() async {
    try {
      final data = await _api.get(_endpoint);
      return data;
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }
}
