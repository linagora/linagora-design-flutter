import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/extensions/string_extension.dart';
import 'package:linagora_design_flutter/avatar/round_avatar_style.dart';

typedef WidgetBuilder = Widget Function(BuildContext context);
typedef WidgetLoadingBuilder = Widget Function(BuildContext, Widget, ImageChunkEvent);

class RoundAvatar extends StatelessWidget {
  /// An optional [ImageProvider] that provides the image to display in the avatar.
  final ImageProvider<Object>? imageProvider;

  /// A function that is called while the image is loading and can be used to customize
  /// the widget that is displayed while the image is loading.
  final WidgetLoadingBuilder? imageLoadingBuilder;
  
  /// A function that is called if there is an error loading the image and can be used to
  /// customize the widget that is displayed when an error occurs.
  /// If [errorBuilder] is null, [text] will be displayed
  final WidgetBuilder? errorBuilder;
 
  /// The [text] to display in the avatar if no image is provided.
  /// If the [text] is longer than [maxChar] characters, it will be truncated to [maxChar] characters.
  final String text;

  /// specify the maximum number of character allowed to display in [text]
  /// when display inside the avatar
  final int maxChar;

  /// The minimum font size to use when displaying the [text].
  /// If the text would be too large to fit in the avatar with the given font size,
  /// the font size will be reduced until the text fits.
  final double minFontSize;

  /// The size of the avatar in logical pixels.
  /// The avatar will be a circle with a diameter equal to this value.
  final double size;

  // The style to use when displaying the text.
  final TextStyle textStyle;

  // A list of `BoxShadow` objects to apply to the avatar.
  final List<BoxShadow>? boxShadows;

  /// A list of colors to use for the linear gradient that is applied to the avatar.
  /// If linearGradientColors is not null, [stops] must be not null and linearGradientColors
  /// must have same length with [stops].
  /// Otherwise, the colors will be derived from the `text` parameter
  /// using the `avatarColors` extension method.
  final List<Color>? linearGradientColors;

  /// If [linearGradientColors] is not null, [stops] must be not null and linearGradientColors
  /// must have same length with [stops]
  final List<double>? stops;

  const RoundAvatar({
    super.key,
    required this.text,
    this.imageProvider,
    this.imageLoadingBuilder,
    this.errorBuilder,
    this.maxChar = RoundAvatarStyle.defaultMaxChar,
    this.size = RoundAvatarStyle.defaultSize,
    this.minFontSize = RoundAvatarStyle.minFontSize,
    this.textStyle = RoundAvatarStyle.defaultTextStype,
    this.boxShadows,
    this.linearGradientColors,
    this.stops
  });

  @override
  Widget build(BuildContext context) {
    var gradientColors = linearGradientColors;
    var text = this.text;

    if (linearGradientColors == null || linearGradientColors!.isEmpty) {
      gradientColors = text.avatarColors;
    }

    if (text.runes.length > RoundAvatarStyle.defaultMaxChar) {
      text = text.substring(0, RoundAvatarStyle.defaultMaxChar).toString();
    }

    Widget textWidget = Center(
      child: AutoSizeText(
        text, 
        minFontSize: minFontSize,
        style: textStyle,
        maxLines: 1));

    Widget child = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: textStyle.color,
        boxShadow: boxShadows,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors!,
          stops: stops ?? RoundAvatarStyle.defaultGradientStops,
        ),
      ),
      width: size,
      height: size,
      child: textWidget
    );

    textWidget = child;

    if (imageProvider != null) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image(
          image: imageProvider!,
          width: size,
          height: size,
          filterQuality: FilterQuality.medium,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) {
            if (errorBuilder != null) {
              return errorBuilder!(context);
            }
            return textWidget;
          },
          loadingBuilder: (context, widget, loadingProcess) {
            if (loadingProcess == null) {
              return widget;
            }
            if (imageLoadingBuilder != null) {
              return imageLoadingBuilder!(context, widget, loadingProcess);
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      child: child,
    );
  }
}