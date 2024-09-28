import 'package:flutter/material.dart';
import 'package:inghub_pomo/services/file_service.dart';

class FileProvider with ChangeNotifier {
  FileProvider() {
    _init();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? _localPath;
  String? get localPath => _localPath;
  final FileService _fileService = FileService();
  void _init() async {
    _isLoading = true;
    final localPath = await _fileService.localPath;
    if (localPath.isSuccess && localPath.data != null) {
      _localPath = localPath.successData;
    } else {
      _errorMessage = localPath.error?.toString();
    }
    _isLoading = false;
  }
}
