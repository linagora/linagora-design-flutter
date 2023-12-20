class LinagoraImagePaths {
  static const String _logo = 'assets/logo/';

  static String get twakeIdLogo => _getImagePath('twake_id_logo.svg');

  static String _getImagePath(String imageName) {
    return _logo + imageName;
  }
}
