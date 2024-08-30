import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Subir imagen a Firebase Storage
  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Definir la ruta de almacenamiento en Firebase Storage
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');

      // Subir el archivo a Firebase Storage
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Obtener la URL de descarga del archivo subido
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error al subir la imagen: $e');
      return null;
    }
  }

  // Descargar la imagen de perfil desde Firebase Storage
  Future<String?> getProfileImageUrl(String userId) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error al obtener la URL de la imagen: $e');
      return null;
    }
  }

  // Eliminar la imagen de perfil de Firebase Storage
  Future<void> deleteProfileImage(String userId) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      await ref.delete();
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }
}
