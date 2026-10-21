import 'dart:typed_data';

class HelpSupportImageModel {
  final Uint8List? imageBytes;
  final String filePath;

  HelpSupportImageModel({
    this.imageBytes,
    required this.filePath,
  });
}