import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/account_switcher/linagora_account_switcher_style.dart';
import 'package:linagora_design_flutter/list_item/linagora_person_tile.dart';

/// One selectable account row of a [LinagoraAccountMenu].
///
/// The host owns [id] typing and any product meaning (own mailbox, delegated,
/// team mailbox, …). This type only carries display data for the row.
@immutable
class LinagoraAccountItem<T> {
  final T id;
  final String name;
  final String? email;

  /// Omitted when null. The row does not draw initials on its own.
  final Widget? avatar;

  const LinagoraAccountItem({
    required this.id,
    required this.name,
    this.email,
    this.avatar,
  });
}

/// A titled group of [LinagoraAccountItem]s inside a [LinagoraAccountMenu].
///
/// Titles and item counts are host-defined: pass as many sections as needed
/// (for example "Your mailbox", "Delegated to you", "Team mailboxes"). Empty
/// [items] hide the whole section.
@immutable
class LinagoraAccountSection<T> {
  final String title;
  final List<LinagoraAccountItem<T>> items;

  const LinagoraAccountSection({required this.title, required this.items});
}

/// Ordered [sections] of accounts with a check on the active [selectedId].
///
/// The menu is data-driven: append or omit sections at the call site when the
/// product gains new mailbox kinds. The switcher popover uses the list as-is.
/// An avatar menu can also pass [header] and [footer].
///
/// Height and scrolling are owned by [LinagoraAccountMenuShell], not by this
/// widget or its section columns. Wrap the menu in the shell (as
/// [LinagoraAccountSwitcher] does) so the panel caps to the available height
/// and scrolls as one unit when content is taller.
class LinagoraAccountMenu<T> extends StatelessWidget {
  final List<LinagoraAccountSection<T>> sections;
  final T? selectedId;
  final ValueChanged<T> onSelected;
  final Widget? header;
  final Widget? footer;
  final LinagoraAccountSwitcherStyle? style;

  const LinagoraAccountMenu({
    super.key,
    required this.sections,
    required this.selectedId,
    required this.onSelected,
    this.header,
    this.footer,
    this.style,
  });

  /// Key of the row showing the account [id].
  static Key itemKey(Object? id) => ValueKey('linagora_account_menu_$id');

  @override
  Widget build(BuildContext context) {
    final tokens = style ?? LinagoraAccountSwitcherStyle.material();
    final header = this.header;
    final footer = this.footer;
    final visibleSections = sections
        .where((section) => section.items.isNotEmpty)
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) header,
        for (final (index, section) in visibleSections.indexed) ...[
          if (index > 0) SizedBox(height: tokens.sectionGap),
          _section(tokens, section),
        ],
        if (footer != null) footer,
      ],
    );
  }

  Widget _section(
    LinagoraAccountSwitcherStyle tokens,
    LinagoraAccountSection<T> section,
  ) {
    return Semantics(
      container: true,
      label: section.title,
      explicitChildNodes: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: tokens.sectionPadding,
            child: ExcludeSemantics(
              child: Text(section.title, style: tokens.sectionTextStyle),
            ),
          ),
          for (final item in section.items) _item(tokens, item),
        ],
      ),
    );
  }

  Widget _item(
    LinagoraAccountSwitcherStyle tokens,
    LinagoraAccountItem<T> item,
  ) {
    final selected = item.id == selectedId;
    return LinagoraPersonTile(
      key: itemKey(item.id),
      name: item.name,
      subtitle: item.email,
      subtitleMaxLines: 1,
      avatar: item.avatar,
      selected: selected,
      onTap: () => onSelected(item.id),
      style: tokens.tileStyle,
      trailing: selected
          ? Icon(
              Icons.check,
              size: tokens.checkIconSize,
              color: tokens.checkIconColor,
            )
          : null,
    );
  }
}
