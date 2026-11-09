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

  /// Empty-card illustration: two people with a share arrow (`#D7E3FA`, 75×48).
  static const String emptyCardShareIcon =
      'assets/images/empty_card_share_icon.svg';

  /// Empty-card illustration: outline mail (`#D7E3FA`, 44×44).
  static const String emptyCardMailIcon =
      'assets/images/empty_card_mail_icon.svg';

  /// Borderless symbols whose drawing fills the view box, so a
  /// `LinagoraSidebarSectionHeaderAction.iconWidget` shows them at its exact
  /// symbol size.
  static const String sidebarSearchIcon = 'assets/images/sidebar_search.svg';
  static const String sidebarAddIcon = 'assets/images/sidebar_add.svg';
}
