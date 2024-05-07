class Message {
  final String message;
  final Map<String, dynamic> body;

  const Message({
    required this.message,
    required this.body,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json['message'] as String,
        body: json['body'] as Map<String, dynamic>,
      );
}


class ApiResponse {
  final String message;
  final ApiResponseBody body;

  ApiResponse({
    required this.message,
    required this.body,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        message: json['message'] as String,
        body: ApiResponseBody.fromJson(json['body']),
      );
}

class ApiResponseBody {
  final Meta meta;
  final List<dynamic> records; // Assuming records can be of various types

  ApiResponseBody({
    required this.meta,
    required this.records,
  });

  factory ApiResponseBody.fromJson(Map<String, dynamic> json) => ApiResponseBody(
        meta: Meta.fromJson(json['meta']),
        records: json['records'] as List<dynamic>,
      );
}

class Meta {
  final int currentPage;
  final int nextPage;
  final int prevPage;
  final int totalPages;
  final int totalRows;
  final int perPage;

  Meta({
    required this.currentPage,
    required this.nextPage,
    required this.prevPage,
    required this.totalPages,
    required this.totalRows,
    required this.perPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json['currentPage'] as int,
        nextPage: json['nextPage'] as int,
        prevPage: json['prevPage'] as int,
        totalPages: json['totalPages'] as int,
        totalRows: json['totalRows'] as int,
        perPage: json['perPage'] as int,
      );
}
