import 'dart:io';

import 'package:inghub_pomo/classes/result_class.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  // 1. 생성자를 private로 선언
  FileService._privateConstructor();

  // 2. static 변수로 유일한 인스턴스 생성
  static final FileService _instance = FileService._privateConstructor();

  // 3. 외부에서 접근할 수 있는 인스턴스 제공자
  factory FileService() => _instance;
  final bool _isInit = false;
  bool get isInit => _isInit;
  // _localSaperator 변수 설정
  String get _localSaperator => Platform.pathSeparator;

  String? _localPath;
  String? get localPath => _localPath;

  Future<void> init() async {
    // 초기화 작업
    final localPathResult = await getLocalPath;
    _localPath = localPathResult.successData;
    if (localPathResult.error != null) {
      throw Exception(localPathResult.error);
    }
  }

  // 애플리케이션 디렉터리 경로 가져오기
  Future<Result<String>> get getLocalPath async {
    if (_localPath != null) {
      return Result(data: _localPath);
    }
    try {
      final directory = await getApplicationDocumentsDirectory();

      // bong_librarian_check 폴더 경로 설정
      final customDirPath = "${directory.path}${_localSaperator}inghub_pomo";
      // 디렉터리가 없으면 생성
      final customDir = Directory(customDirPath);
      if (!(await customDir.exists())) {
        await customDir.create(recursive: true); // 하위 폴더까지 생성
      }
      return Result(data: customDirPath);
    } catch (e) {
      return Result(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  Future<Result<bool>> appendStringToFile({
    required String data,
    required String fileName,
    required String directoryPath,
  }) async {
    try {
      final path = join(directoryPath, fileName);
      final directory = Directory(directoryPath);
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }
      final file = File(path);
      await file.writeAsString(data, mode: FileMode.writeOnlyAppend);
      return Result(data: true);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<String>> readJsonFile({
    required String fileName,
    required String directoryPath,
  }) async {
    try {
      final file = File("$directoryPath$_localSaperator$fileName");

      if (!(await file.exists())) {
        throw Exception("File not found");
      }

      final data = await file.readAsString();

      return Result(data: data);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
