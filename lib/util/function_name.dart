String getFunctionName() {
  // Get the stack trace
  StackTrace stackTrace = StackTrace.current;

  // Convert the stack trace to a string
  String stackTraceString = stackTrace.toString();

  // Split the stack trace string by line breaks
  List<String> lines = stackTraceString.split('\n');

  // The second line usually contains information about the current function
  if (lines.length > 1) {
    // Extract the function name from the second line
    String functionName = lines[1].trim();

    // Return the function name
    return functionName;
  }

  // Return a default value if the function name couldn't be extracted
  return 'Unknown Function';
}
