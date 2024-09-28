// lib/services/isolate_file_service.dart

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:inghub_pomo/classes/isolate_message_class.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:path_provider/path_provider.dart';
// lib/models/response_message.dart

class IsolateFileService {
  // 싱글톤 인스턴스
  IsolateFileService._internal();
  static final IsolateFileService _instance = IsolateFileService._internal();

  // _localSeparator 변수 설정
  String get _localSeparator => Platform.pathSeparator;

  // 외부에서 접근할 수 있는 팩토리 생성자
  factory IsolateFileService() {
    return _instance;
  }

  // ReceivePort 생성
  final ReceivePort _receivePortFileService = ReceivePort();

  // SendPort
  SendPort? _sendPortFileService;

  // Isolate 인스턴스
  late Isolate _isolateFileService;

  // 요청 ID 관리
  int _requestId = 0;

  // Completer 맵
  final Map<int, Completer<dynamic>> _completers = {};

  // 초기화 플래그
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Completer for initialization
  final Completer<void> _initCompleter = Completer<void>();

  String? _localDirPath;
  String? get localDirPath => _localDirPath;

  // 초기화 메서드
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 애플리케이션 디렉터리 경로 가져오기
      final localPathResult = await getLocalPath();
      if (localPathResult.isError) {
        throw localPathResult.error!;
      }
      if (localPathResult.isNull) {
        throw Exception('Local path is null');
      }
      if (localPathResult.isSuccess) {
        _localDirPath = localPathResult.successData;
      }

      // Isolate 생성
      _isolateFileService = await Isolate.spawn(
          _isolateFunction, _receivePortFileService.sendPort);

      // ReceivePort 리스너 설정
      _receivePortFileService.listen((message) {
        if (_sendPortFileService == null) {
          // 첫 번째 메시지는 SendPort
          if (message is SendPort) {
            _sendPortFileService = message;
            _isInitialized = true;
            _initCompleter.complete();
          } else if (message is Map<String, dynamic> &&
              message.containsKey('sendPort')) {
            _sendPortFileService = message['sendPort'] as SendPort;
            _isInitialized = true;
            _initCompleter.complete();
          }
        } else {
          // 그 이후 메시지는 응답
          _handleMessage(message);
        }
      });

      // 기다리기
      await _initCompleter.future;
    } catch (e) {
      await shutdown();
      rethrow;
    }
  }

  // 애플리케이션 디렉터리 경로 가져오기
  Future<Result<String>> getLocalPath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      // inghub_pomo 폴더 경로 설정
      final customDirPath = "${directory.path}${_localSeparator}inghub_pomo";
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

  // 메시지 핸들링 메서드
  void _handleMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      final response = ResponseMessage.fromMap(message);
      final int id = response.id;
      try {
        if (_completers.containsKey(id)) {
          if (response.error != null) {
            _completers[id]!.completeError(Exception(response.error));
          } else {
            _completers[id]!.complete(response.result);
          }
        }
      } catch (e, stackTrace) {
        // 예외 로깅

        print('Error completing completer for id $id: $e');
        print(stackTrace);
      } finally {
        _completers.remove(id);
      }
    }
  }

  /// 작업 실행 메서드
  Future<R> runOperation<R>(String operation, dynamic data) async {
    if (!_isInitialized) {
      await initialize();
    }

    final int id = _requestId++;
    final Completer<R> completer = Completer<R>();
    _completers[id] = completer;

    // 요청 메시지 생성
    final request = RequestMessage(
      id: id,
      operation: operation,
      data: data,
    );

    // Isolate로 작업 요청 전송 (Map으로 변환)
    _sendPortFileService!.send(request.toMap());

    // 타임아웃 설정 (예: 10초)
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        if (_completers.containsKey(id)) {
          _completers[id]!.completeError(
            TimeoutException('Request $id timed out'),
          );
          _completers.remove(id);
        }
        throw TimeoutException('Request $id timed out');
      },
    );
  }

  /// 파일 읽기 메서드
  Future<Result<String>> readFile(String path) async {
    try {
      String content = await runOperation<String>('readFile', path);
      return Result(data: content);
    } catch (e) {
      return Result(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// 파일 쓰기 메서드
  Future<Result<String>> writeFile(String path, String content) async {
    try {
      String result = await runOperation<String>('writeFile', {
        'path': path,
        'content': content,
      });
      return Result(data: result);
    } catch (e) {
      return Result(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Isolate 종료 메서드
  Future<void> shutdown() async {
    _isolateFileService.kill(priority: Isolate.immediate);
    _receivePortFileService.close();
    _isInitialized = false;
  }

  // Isolate에서 실행될 함수
  static void _isolateFunction(SendPort mainSendPort) {
    final ReceivePort isolateReceivePort = ReceivePort();

    // 메인 Isolate로 SendPort 보내기
    mainSendPort.send(isolateReceivePort.sendPort);

    // 메시지 수신 대기
    isolateReceivePort.listen((message) async {
      if (message is Map<String, dynamic>) {
        final request = RequestMessage.fromMap(message);
        final int id = request.id;
        final String operation = request.operation;
        final dynamic data = request.data;
        dynamic result;
        String? error;

        try {
          switch (operation) {
            case 'readFile':
              if (data is String) {
                // data는 파일 경로
                final file = File(data);
                if (await file.exists()) {
                  result = await file.readAsString();
                } else {
                  throw Exception('File does not exist at path: $data');
                }
              } else {
                throw Exception(
                    'Data must be a String (file path) for readFile operation');
              }
              break;
            case 'writeFile':
              if (data is Map<String, dynamic>) {
                final String path = data['path'];
                final String content = data['content'];
                final file = File(path);
                await file.writeAsString(content);
                result = 'File written successfully';
              } else {
                throw Exception(
                    'Data must be a Map with "path" and "content" for writeFile operation');
              }
              break;
            default:
              throw Exception('Unknown operation: $operation');
          }
        } catch (e) {
          error = e.toString();
        }

        // 응답 메시지 생성
        final response = ResponseMessage(
          id: id,
          result: result,
          error: error,
        );

        // 결과 전송
        mainSendPort.send(response.toMap());
      }
    });
  }
}

// 작업 큐를 위한 클래스 (현재 예제에서는 사용하지 않음)
class _QueuedOperation {
  final int id;
  final String operation;
  final dynamic data;
  final Completer completer;
  final Duration timeout;
  final SendPort sendPort;

  _QueuedOperation(this.id, this.operation, this.data, this.completer,
      this.timeout, this.sendPort);
}
