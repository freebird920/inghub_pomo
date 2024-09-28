// lib/providers/isolate_provider.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/services/file_service.dart';
import 'package:inghub_pomo/services/isolate_file_service.dart';

class IsolateProvider with ChangeNotifier {
  final IsolateFileService _isolateService = IsolateFileService();
  final FileService _fileService = FileService();
  String get _localSaperator => Platform.pathSeparator;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  IsolateProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    // FileService를 통해 디렉토리 경로 가져오기
    Result<String> pathResult = await _fileService.localPath;
    if (pathResult.isSuccess) {
      try {
        await _isolateService.initialize();
        _errorMessage = null;
      } catch (e) {
        _errorMessage = e.toString();
      }
    } else {
      _errorMessage = pathResult.error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Result<String>> createTestJson() async {
    _isLoading = true;
    notifyListeners();

    try {
      String filePath =
          '${_isolateService.localDirPath}${_localSaperator}test.json';
      String content = '{"name": "test"}';
      String result =
          (await _isolateService.writeFile(filePath, content)).successData;
      _isLoading = false;
      notifyListeners();
      return Result(data: result);
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<String>> readTestJson() async {
    _isLoading = true;
    notifyListeners();

    try {
      String directoryPath = (await _fileService.localPath).data!;
      String filePath = '$directoryPath${_localSaperator}test.json';
      String content = (await _isolateService.readFile(filePath)).successData;
      _isLoading = false;
      notifyListeners();
      return Result(data: content);
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  void dispose() {
    _isolateService.shutdown();
    super.dispose();
  }
}
