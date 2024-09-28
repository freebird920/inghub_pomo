class ResponseMessage {
  final int id;
  final dynamic result;
  final String? error;

  ResponseMessage({
    required this.id,
    this.result,
    this.error,
  });

  // Map으로 변환 (직렬화)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'result': result,
      'error': error,
    };
  }

  // Map에서 객체 생성 (역직렬화)
  factory ResponseMessage.fromMap(Map<String, dynamic> map) {
    return ResponseMessage(
      id: map['id'],
      result: map['result'],
      error: map['error'],
    );
  }
}
// lib/models/request_message.dart

class RequestMessage {
  final int id;
  final String operation;
  final dynamic data;

  RequestMessage({
    required this.id,
    required this.operation,
    this.data,
  });

  // Map으로 변환 (직렬화)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operation': operation,
      'data': data,
    };
  }

  // Map에서 객체 생성 (역직렬화)
  factory RequestMessage.fromMap(Map<String, dynamic> map) {
    return RequestMessage(
      id: map['id'],
      operation: map['operation'],
      data: map['data'],
    );
  }
}
