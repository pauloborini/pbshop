class HTTPException implements Exception {
  final String message;
  final int statusCode;

  HTTPException({required this.message, required this.statusCode});

  @override
  String toString() {
    return message;
  }
}
