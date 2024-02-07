base class AppError extends Error {
  AppError(this.message, [this.reason]);

  final String message;
  final String? reason;

  String fullMessage() {
    if (reason != null) {
      return '$message: $reason';
    }
    return message;
  }
}
