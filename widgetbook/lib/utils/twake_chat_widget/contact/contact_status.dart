enum ContactStatus {
  active,
  inactive;

  String get label {
    switch (this) {
      case ContactStatus.active:
        return 'Active';
      case ContactStatus.inactive:
        return 'Inactive';
      default:
        return '';
    }
  }
}
