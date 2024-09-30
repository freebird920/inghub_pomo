import 'package:inghub_pomo/services/file_service.dart';
import 'package:path/path.dart';

class LogService {
  final FileService _fileService = FileService();
  LogService._internal();
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  bool _isInit = false;
  bool get isInit => _isInit;

  Future<void> init() async {
    _isInit = false;
    await _fileService.init();
    _isInit = true;
    return;
  }

  Future<void> log(String message) async {
    try {
      if (!_fileService.isInit) {
        await init();
      }
      if (_fileService.localPath == null) {
        throw Exception("Local path is not initialized");
      }
      final String nowString = DateTime.now().toIso8601String();
      final logFile = await _fileService.appendStringToFile(
        data: "[$nowString] $message\n",
        directoryPath: join(
          _fileService.localPath!,
          "logs",
        ),
        fileName: "${nowString.split('T')[0]}.log",
      );
      if (logFile.isError) {
        throw Exception(logFile.error);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
