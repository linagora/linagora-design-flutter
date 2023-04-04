import 'dart:ui';

abstract class LinagoraColors {
  final Color accent;

  final Color? _accentDark;

  Color get accentDark => _accentDark ?? accent;

  LinagoraColors({
    required this.accent,
    accentDark,
  }) : _accentDark = accentDark;
}
