// https://developer.mozilla.org/en-US/docs/Web/API/Notification/requestPermission_static
enum CozyNotificationStatus {
  isGranted(jsEquivalent: 'granted'),
  isDenied(jsEquivalent: 'denied'),
  isDefault(jsEquivalent: 'default'),
  isUndefined(jsEquivalent: 'undefined');

  const CozyNotificationStatus({required this.jsEquivalent});

  final String jsEquivalent;

  static CozyNotificationStatus fromJs(String status) {
    switch (status) {
      case 'granted':
        return CozyNotificationStatus.isGranted;
      case 'denied':
        return CozyNotificationStatus.isDenied;
      case 'default':
        return CozyNotificationStatus.isDefault;
      default:
        return CozyNotificationStatus.isUndefined;
    }
  }
}
