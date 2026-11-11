/// For svg images, consider compile with [vector_graphics_compiler] for various
/// benefits. See more at https://pub.dev/packages/flutter_svg#precompiling-and-optimizing-svgs
class LinagoraDesignImages {
  const LinagoraDesignImages._();

  static const String packageName = 'linagora_design_flutter';
  static const String _assetPrefix = 'packages/$packageName/assets';

  static const String svgBytesClose = '$_assetPrefix/images/close.svg.vec';
  static const String calendarTodayIcon = 'assets/images/calendar_today.svg';
  static const String videoConferenceIcon =
      'assets/images/video_conference_icon.svg';
  static const String copyLinkIcon = 'assets/images/copy_link_icon.svg';

  /// Person-tile remove control (Material delete, outline, `#7A7781`).
  static const String deleteIcon = 'assets/images/delete_icon.svg';

  /// Borderless symbols whose drawing fills the view box, so a
  /// `LinagoraSidebarSectionHeaderAction.iconWidget` shows them at its exact
  /// symbol size.
  static const String sidebarSearchIcon = 'assets/images/sidebar_search.svg';
  static const String sidebarAddIcon = 'assets/images/sidebar_add.svg';
}
