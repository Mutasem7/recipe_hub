// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<String?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return image.path; // إرجاع مسار الصورة
    }
    return null; // إذا لم يتم اختيار صورة
  }
}
