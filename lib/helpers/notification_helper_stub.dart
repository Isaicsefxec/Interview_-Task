/// Empty shim so non‑web builds still have a matching API.
Future<void> requestWebNotificationPermission() async {
  // No‑op on Android, iOS, Windows, macOS, Linux.
}
