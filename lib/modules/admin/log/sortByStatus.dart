List<Map<String, dynamic>> sortByStatus(List<Map<String, dynamic>> logs) {
  // Reserve lists to avoid resizing during adding
  final successLogs = <Map<String, dynamic>>[];
  final failureLogs = <Map<String, dynamic>>[];

  for (final log in logs) {
    final status = log['status'];
    if (status == 'Success') {
      successLogs.add(log);
    } else if (status == 'Failure') {
      failureLogs.add(log);
    }
  }

  return [...successLogs, ...failureLogs]; // Merge both
}