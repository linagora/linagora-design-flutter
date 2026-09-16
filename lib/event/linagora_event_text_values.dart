import 'package:flutter/widgets.dart';
import 'package:linkify/linkify.dart';
import 'package:linagora_design_flutter/event/linagora_event_card_data.dart';

/// Converts display text into event-card values while preserving its exact
/// punctuation and whitespace.
abstract final class LinagoraEventTextValues {
  static List<LinagoraEventValue> fromText(
    String text, {
    ValueChanged<String>? onOpenLink,
    ValueChanged<String>? onOpenEmail,
  }) {
    final elements = linkify(
      text,
      options: const LinkifyOptions(
        removeWww: true,
        looseUrl: true,
        defaultToHttps: true,
      ),
      linkifiers: const [EmailLinkifier(), UrlLinkifier()],
    );

    return [
      for (final element in elements)
        if (element.text.isNotEmpty)
          _value(
            element,
            onOpenLink: onOpenLink,
            onOpenEmail: onOpenEmail,
          ),
    ];
  }

  static LinagoraEventValue _value(
    LinkifyElement element, {
    ValueChanged<String>? onOpenLink,
    ValueChanged<String>? onOpenEmail,
  }) {
    if (element is UrlElement) {
      return LinagoraEventValue.link(
        element.text,
        onTap: onOpenLink == null
            ? null
            : () => onOpenLink(element.url),
      );
    }
    if (element is EmailElement) {
      return LinagoraEventValue.link(
        element.text,
        onTap: onOpenEmail == null
            ? null
            : () => onOpenEmail(element.emailAddress),
      );
    }
    return LinagoraEventValue(element.text);
  }
}
