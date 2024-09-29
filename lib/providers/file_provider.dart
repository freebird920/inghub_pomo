import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/managers/snack_bar_manager.dart';
import 'package:inghub_pomo/services/file_service.dart';

class FileProvider with ChangeNotifier {
  FileProvider() {
    _init();
  }

  bool _isInit = false;
  bool get isInit => _isInit;
  // 1. _isLoading 변수 설정
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // 2. _errorMessage 변수 설정
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  // 3. _localPath 변수 설정
  String? _localPath;
  String? get localPath => _localPath;

  // 4. FileService 인스턴스 생성
  final FileService _fileService = FileService();

  // 5. 초기화 코드 작성
  void _init() async {
    if (_isLoading || _isInit) return;
    _isLoading = true;
    final localPath = await _fileService.getLocalPath;
    if (localPath.isSuccess && localPath.data != null) {
      _localPath = localPath.successData;
    } else {
      _errorMessage = localPath.error?.toString();
    }
    _isLoading = false;
    _isInit = true;
    notifyListeners();
  }

  Future<Result<String>> readJsonFile({
    required String directoryPath,
    required String fileName,
  }) async {
    try {
      final result = await _fileService.readJsonFile(
        fileName: fileName,
        directoryPath: directoryPath,
      );
      if (result.isError) {
        throw result.error!;
      }
      if (result.isNull) {
        throw Exception("Data is null");
      }
      if (!result.isSuccess) {
        throw Exception("Unknown error");
      }
      return Result(data: "");
    } catch (e) {
      SnackBarManager()
          .showSimpleSnackBar(e is Exception ? e.toString() : "Unknown error");
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
