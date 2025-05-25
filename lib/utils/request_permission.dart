import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  PermissionStatus status = await Permission.photos.request();
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    // The user denied the permission, you can show a dialog or a snackbar
    return false;
  } else if (status.isPermanentlyDenied) {
    // The user has permanently denied the permission, you can open app settings
    await openAppSettings();
    return false;
  }
  return false;
}
