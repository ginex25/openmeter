import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> askForExternalStoragePermission() async {
    var status = await Permission.manageExternalStorage.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
    }

    return false;
  }
}
