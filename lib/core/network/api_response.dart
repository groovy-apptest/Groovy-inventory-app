class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromData,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromData != null
          ? fromData(json['data'])
          : null,
    );
  }
}
