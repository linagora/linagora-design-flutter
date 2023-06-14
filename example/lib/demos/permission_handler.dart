import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
  photos,
  camera
}

class PermissionHandlerService {
  static final PermissionHandlerService _instance = PermissionHandlerService._internal();

  factory PermissionHandlerService() {
    return _instance;
  }

  PermissionHandlerService._internal();


  Future<PermissionStatus> getCurrentPermission(PermissionType permissionType) async {
    switch (permissionType) {
      case PermissionType.photos:
        if (Platform.isAndroid) {
          return await Permission.storage.request();
        } else {
          return await Permission.photos.request();
        }
      case PermissionType.camera:
        return await Permission.camera.request();
    }
  }
}