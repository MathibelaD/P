import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final _client = Supabase.instance.client;

  /// Uploads a file to the given bucket and returns the public URL.
  Future<String?> uploadImage({
    required File file,
    required String bucket,
    String? pathPrefix, // optional folder
  }) async {
    try {
      final fileExt = file.path.split('.').last;
      final fileName = const Uuid().v4(); // random unique name
      final filePath = pathPrefix != null
          ? '$pathPrefix/$fileName.$fileExt'
          : '$fileName.$fileExt';

      final response = await _client.storage.from(bucket).upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      if (response.isEmpty) {
        throw Exception('Upload failed');
      }

      final publicUrl = _client.storage.from(bucket).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print('❌ Storage upload error: $e');
      return null;
    }
  }
}
