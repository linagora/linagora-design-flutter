import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_ref_colors.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';
import 'package:linagora_design_flutter/spacings/linagora_spacing.dart';
import 'package:linagora_design_flutter/style/linagora_text_theme.dart';

/// A pill of the reactions row displayed under a message bubble.
class LinagoraReactionChip extends StatelessWidget {
  /// Gap between two chips of the same row.
  static const double spacing = LinagoraSpacing.base * 0.5;
  static const double height = LinagoraSpacing.base * 3.5;

  static const double _contentSize = LinagoraSpacing.base * 2.5;
  // Draws an emoji glyph of about 18px, as in Figma. The forced strut gives
  // the line the height of the glyph, so that centering the line centers it.
  //
  // Apple Color Emoji draws its glyph at the start of a wider advance, which
  // fits the content box. The other emoji fonts center a larger glyph in an
  // advance wider than the box: it is drawn smaller, centered past the box.
  static bool get _hasAppleEmoji =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);
  static double get _emojiFontSize => _hasAppleEmoji ? 19 : 17.5;
  static StrutStyle get _emojiStrut => StrutStyle(
    fontFamily: 'TwakeInter',
    package: 'linagora_design_flutter',
    fontSize: _emojiFontSize,
    height: 1,
    forceStrutHeight: true,
  );
  static const double _radius = LinagoraSpacing.base * 2;
  static const double _gap = LinagoraSpacing.base * 0.5;
  static const EdgeInsets _reactionPadding = EdgeInsets.only(
    left: LinagoraSpacing.base * 0.5,
    right: LinagoraSpacing.base * 0.75,
  );
  static const EdgeInsets _contentOnlyPadding = EdgeInsets.all(
    LinagoraSpacing.base * 0.5,
  );
  static const EdgeInsets _remainingPadding = EdgeInsets.symmetric(
    horizontal: LinagoraSpacing.base * 0.75,
  );

  final _ChipKind _kind;
  final String? _emoji;
  final Widget? _image;
  final int? _count;

  /// Read by screen readers instead of the content of the chip, such as
  /// `👍, 3 reactions`.
  final String? semanticLabel;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;

  /// A reaction with a unicode [emoji]. [count] is hidden when null.
  const LinagoraReactionChip({
    super.key,
    required String emoji,
    int? count,
    this.semanticLabel,
    this.onTap,
    this.onLongPress,
  }) : _kind = _ChipKind.reaction,
       _emoji = emoji,
       _image = null,
       _count = count,
       onTapDown = null;

  /// A reaction with a custom emoji [image]. [count] is hidden when null.
  const LinagoraReactionChip.image({
    super.key,
    required Widget image,
    int? count,
    this.semanticLabel,
    this.onTap,
    this.onLongPress,
  }) : _kind = _ChipKind.reaction,
       _emoji = null,
       _image = image,
       _count = count,
       onTapDown = null;

  /// The number of reactions that are not displayed in the row. Replaces
  /// [LinagoraReactionChip.more] to open the full list of reactions.
  const LinagoraReactionChip.remaining({
    super.key,
    required int count,
    this.semanticLabel,
    this.onTap,
    this.onTapDown,
  }) : _kind = _ChipKind.remaining,
       _emoji = null,
       _image = null,
       _count = count,
       onLongPress = null;

  /// The button opening the full list of reactions.
  const LinagoraReactionChip.more({
    super.key,
    this.semanticLabel,
    this.onTap,
    this.onTapDown,
  }) : _kind = _ChipKind.more,
       _emoji = null,
       _image = null,
       _count = null,
       onLongPress = null;

  Widget? get _content {
    final emoji = _emoji;
    return switch (_kind) {
      _ChipKind.reaction => emoji != null ? _emojiText(emoji) : _image,
      _ChipKind.remaining => null,
      _ChipKind.more => const Icon(
        Icons.more_horiz_rounded,
        size: _contentSize,
      ),
    };
  }

  Widget _emojiText(String emoji) {
    final text = Text(
      emoji,
      softWrap: false,
      overflow: TextOverflow.visible,
      textScaler: TextScaler.noScaling,
      strutStyle: _emojiStrut,
      style: TextStyle(fontSize: _emojiFontSize),
    );
    if (_hasAppleEmoji) return Center(child: text);

    return OverflowBox(
      minWidth: 0,
      minHeight: 0,
      maxWidth: double.infinity,
      child: text,
    );
  }

  String? get _label => switch (_kind) {
    _ChipKind.reaction => _count?.toString(),
    _ChipKind.remaining => '+$_count',
    _ChipKind.more => null,
  };

  EdgeInsets get _padding => switch (_kind) {
    _ChipKind.reaction =>
      _count == null ? _contentOnlyPadding : _reactionPadding,
    _ChipKind.remaining => _remainingPadding,
    _ChipKind.more => _contentOnlyPadding,
  };

  @override
  Widget build(BuildContext context) {
    final sysColors = LinagoraSysColors.material();
    final labelColor = LinagoraRefColors.material().neutral[50];
    final borderRadius = BorderRadius.circular(_radius);
    final content = _content;
    final label = _label;

    return Material(
      color: sysColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: sysColors.onPrimary),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        onTapDown: onTapDown,
        borderRadius: borderRadius,
        child: Semantics(
          button: onTap != null,
          label: semanticLabel,
          excludeSemantics: semanticLabel != null,
          child: Container(
            height: height,
            constraints: const BoxConstraints(minWidth: height),
            padding: _padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (content != null)
                  IconTheme.merge(
                    data: IconThemeData(color: labelColor),
                    child: SizedBox.square(
                      dimension: _contentSize,
                      child: content,
                    ),
                  ),
                if (content != null && label != null)
                  const SizedBox(width: _gap),
                if (label != null)
                  Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    style: LinagoraTextTheme.material().bodyMedium?.copyWith(
                      color: labelColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ChipKind { reaction, remaining, more }
