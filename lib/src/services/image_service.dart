import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();

  Future<bool> requestPermissions() async {
    if (kIsWeb) {
      // Web doesn't need explicit permission requests
      return true;
    }

    if (Platform.isAndroid) {
      final cameraPermission = await Permission.camera.request();
      final photosPermission = await Permission.photos.request();
      return cameraPermission.isGranted && photosPermission.isGranted;
    } else if (Platform.isIOS) {
      final cameraPermission = await Permission.camera.request();
      final photosPermission = await Permission.photos.request();
      return cameraPermission.isGranted && photosPermission.isGranted;
    }

    // Desktop platforms typically don't need permissions for file access
    return true;
  }

  Future<XFile?> pickImageFromGallery() async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission && !kIsWeb) {
        throw Exception('Permission not granted for gallery access');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  Future<XFile?> pickImageFromCamera() async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission && !kIsWeb) {
        throw Exception('Permission not granted for camera access');
      }

      // Check if camera is available (mainly for desktop/web)
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        // Desktop platforms might not have camera access
        return await pickImageFromGallery();
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image;
    } catch (e) {
      print('Error picking image from camera: $e');
      // Fallback to gallery if camera fails
      return await pickImageFromGallery();
    }
  }

  Future<List<XFile>> pickMultipleImages() async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission && !kIsWeb) {
        throw Exception('Permission not granted for gallery access');
      }

      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return images;
    } catch (e) {
      print('Error picking multiple images: $e');
      return [];
    }
  }

  Future<void> showImageSourceDialog({
    required Function(XFile?) onImageSelected,
    required Function() showGallery,
    required Function() showCamera,
  }) async {
    // This method will be used by the UI to show source selection
    // Implementation will be in the widget layer
  }

  // Helper method to get image size
  Future<Map<String, int>?> getImageSize(String imagePath) async {
    try {
      if (kIsWeb) {
        // Web implementation would need different approach
        return null;
      }

      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) return null;

      // For now, return null - image size calculation would require additional packages
      return null;
    } catch (e) {
      print('Error getting image size: $e');
      return null;
    }
  }

  // Helper method to validate image file
  bool isValidImageFile(String filePath) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final extension = filePath.toLowerCase().split('.').last;
    return validExtensions.contains('.$extension');
  }

  // Convert image to base64 (pure base64 without data URI prefix)
  Future<String?> convertImageToBase64(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      print('Error converting image to base64: $e');
      return null;
    }
  }

  // Get image data for API sending
  Future<Map<String, dynamic>?> getImageDataForApi(XFile imageFile) async {
    try {
      final base64String = await convertImageToBase64(imageFile);
      if (base64String == null) return null;
      
      final bytes = await imageFile.readAsBytes();
      
      return {
        'filename': imageFile.name,
        'mimeType': _getMimeType(imageFile.name),
        'size': bytes.length,
        'content': base64String, // Pure base64 in content field
      };
    } catch (e) {
      print('Error getting image data for API: $e');
      return null;
    }
  }

  String _getMimeType(String filename) {
    final extension = filename.toLowerCase().split('.').last;
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}