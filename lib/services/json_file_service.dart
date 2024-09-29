import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/services/file_service.dart';

class JsonFileService {
  // 1. 생성자를 private로 선언
  JsonFileService._privateConstructor();
  // 2. static 변수로 유일한 인스턴스 생성
  static final JsonFileService _instance =
      JsonFileService._privateConstructor();

  // 3. 외부에서 접근할 수 있는 인스턴스 제공자
  factory JsonFileService() {
    JsonFileService()._initialize();
    return _instance;
  }
  // _isLoading 변수 설정
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // _errorMessage 변수 설정
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // _localPath 변수 설정
  String? _localPath;
  String? get localPath => _localPath;

  void _initialize() async {
    // 초기화 코드 작성
    _isLoading = true;
    // 파일 경로 가져오기
    final localPath = await _fileService.getLocalPath;
    if (localPath.isSuccess && localPath.data != null) {
      _localPath = localPath.successData;
    } else {
      _errorMessage = localPath.error?.toString();
    }
    _isLoading = false;
  }

  // FileService 인스턴스 생성
  final _fileService = FileService();
  // 파일 경로 가져오기

  Future<Result<String>> readJsonFile(String path) async {
    try {
      return Result(data: "");
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
