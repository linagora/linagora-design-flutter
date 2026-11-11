import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: LinagoraAccountSwitcher)
Widget linagoraAccountSwitcherUseCase(BuildContext context) {
  final showAvatar = context.knobs.boolean(label: 'Avatar', initialValue: true);
  final compact = context.knobs.boolean(label: 'Compact', initialValue: false);
  final catalog = _catalogKnobs(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  var style = isDark
      ? LinagoraAccountSwitcherStyle.dark()
      : LinagoraAccountSwitcherStyle.material();
  if (compact) style = style.compact();

  return ColoredBox(
    color: _surface(isDark),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: AlignmentDirectional.topEnd,
        child: _SwitcherPreview(
          compact: compact,
          showAvatar: showAvatar,
          style: style,
          sections: catalog.sections,
          initialSelected: catalog.selected,
        ),
      ),
    ),
  );
}

class _SwitcherPreview extends StatefulWidget {
  final bool compact;
  final bool showAvatar;
  final LinagoraAccountSwitcherStyle style;
  final List<LinagoraAccountSection<String>> sections;
  final String initialSelected;

  const _SwitcherPreview({
    required this.compact,
    required this.showAvatar,
    required this.style,
    required this.sections,
    required this.initialSelected,
  });

  @override
  State<_SwitcherPreview> createState() => _SwitcherPreviewState();
}

class _SwitcherPreviewState extends State<_SwitcherPreview> {
  late String _selected = widget.initialSelected;

  @override
  void didUpdateWidget(covariant _SwitcherPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelected != oldWidget.initialSelected) {
      _selected = widget.initialSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = _accountById(_selected);
    final avatarSize = widget.style.chipAvatarSize;
    return LinagoraAccountSwitcher<String>(
      label: widget.compact ? null : 'Viewing ${account.name}',
      semanticLabel: widget.compact ? 'Switch mailbox' : null,
      menuSemanticLabel: 'Switch mailbox',
      selectedId: _selected,
      onSelected: (id) => setState(() => _selected = id),
      style: widget.style,
      avatar: widget.showAvatar ? _avatar(account.initials, avatarSize) : null,
      sections: widget.sections,
    );
  }
}

@widgetbook.UseCase(name: 'Default', type: LinagoraAccountMenu)
Widget linagoraAccountMenuUseCase(BuildContext context) {
  final knobs = _menuKnobs(context);
  return ColoredBox(
    color: _surface(knobs.isDark),
    child: Padding(
      padding: const EdgeInsets.all(LinagoraSpacing.base * 3),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: _AccountMenuPreview(knobs: knobs),
      ),
    ),
  );
}

class _AccountMenuPreview extends StatefulWidget {
  final ({
    bool isDark,
    bool showHeader,
    bool showFooter,
    bool showBadge,
    String selected,
    List<LinagoraAccountSection<String>> sections,
    LinagoraAccountSwitcherStyle tokens,
  }) knobs;

  const _AccountMenuPreview({required this.knobs});

  @override
  State<_AccountMenuPreview> createState() => _AccountMenuPreviewState();
}

class _AccountMenuPreviewState extends State<_AccountMenuPreview> {
  late String _selected = widget.knobs.selected;

  @override
  void didUpdateWidget(covariant _AccountMenuPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.knobs.selected != oldWidget.knobs.selected) {
      _selected = widget.knobs.selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final knobs = widget.knobs;
    final tokens = knobs.tokens;
    final account = _accountById(_selected);
    final maxHeight = MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).vertical -
        LinagoraSpacing.base * 6;
    return LinagoraAccountMenuShell(
      maxHeight: maxHeight,
      style: tokens,
      width: tokens.menuWidth,
      child: LinagoraAccountMenu<String>(
        selectedId: _selected,
        onSelected: (id) => setState(() => _selected = id),
        style: tokens,
        header: knobs.showHeader
            ? _menuHeader(account, tokens, knobs.isDark, knobs.showBadge)
            : null,
        footer: knobs.showFooter ? _menuFooter(tokens) : null,
        sections: knobs.sections,
      ),
    );
  }
}

({
  bool isDark,
  bool showHeader,
  bool showFooter,
  bool showBadge,
  String selected,
  List<LinagoraAccountSection<String>> sections,
  LinagoraAccountSwitcherStyle tokens,
}) _menuKnobs(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final catalog = _catalogKnobs(context);
  return (
    isDark: isDark,
    showHeader: context.knobs.boolean(label: 'Header', initialValue: true),
    showFooter: context.knobs.boolean(label: 'Footer', initialValue: true),
    showBadge: context.knobs.boolean(
      label: 'Status badge',
      initialValue: false,
    ),
    selected: catalog.selected,
    sections: catalog.sections,
    tokens: (isDark
            ? LinagoraAccountSwitcherStyle.dark()
            : LinagoraAccountSwitcherStyle.material())
        .avatarMenu(),
  );
}

/// Sample section knobs. Apps build any number of titled sections the same way.
({
  String selected,
  List<LinagoraAccountSection<String>> sections,
}) _catalogKnobs(BuildContext context) {
  final showDelegated = context.knobs.boolean(
    label: 'Show Delegated to you',
    initialValue: true,
  );
  final showTeam = context.knobs.boolean(
    label: 'Show Team mailboxes',
    initialValue: true,
  );
  final delegatedCount = context.knobs.object.dropdown(
    label: 'Delegated count',
    options: List<int>.generate(10, (index) => index + 1),
    labelBuilder: (count) => '$count',
  );
  final sections = _sections(
    showDelegated: showDelegated,
    delegatedCount: delegatedCount,
    showTeamMailboxes: showTeam,
  );
  final ids = [
    for (final section in sections)
      for (final item in section.items) item.id,
  ];
  final selected = context.knobs.object.dropdown(
    label: 'Selected',
    options: ids.isEmpty ? const ['me'] : ids,
    labelBuilder: (id) => _accountById(id).name,
  );
  return (selected: selected, sections: sections);
}

Widget _menuHeader(
  _DemoAccount account,
  LinagoraAccountSwitcherStyle tokens,
  bool isDark,
  bool showBadge,
) {
  return LinagoraAccountMenuHeader(
    avatar: _avatar(account.initials, tokens.headerAvatarSize),
    name: account.name,
    email: account.email,
    onCopyEmail: () => Clipboard.setData(ClipboardData(text: account.email)),
    copyTooltip: 'Copy email',
    badge: showBadge
        ? _statusBadge(isDark, account.badgeLabel ?? 'Personal mailbox')
        : null,
    style: tokens,
  );
}

Widget _menuFooter(LinagoraAccountSwitcherStyle tokens) {
  return LinagoraAccountMenuActions(
    manageLabel: 'Manage account',
    signOutLabel: 'Sign out',
    onManageAccount: () {},
    onSignOut: () {},
    style: tokens,
  );
}

List<LinagoraAccountSection<String>> _sections({
  required bool showDelegated,
  required int delegatedCount,
  required bool showTeamMailboxes,
}) {
  return [
    LinagoraAccountSection(
      title: 'Your mailbox',
      items: [_item(_ownAccount)],
    ),
    if (showDelegated)
      LinagoraAccountSection(
        title: 'Delegated to you',
        items: [
          for (final account in _delegatedAccounts.take(delegatedCount))
            _item(account),
        ],
      ),
    if (showTeamMailboxes)
      LinagoraAccountSection(
        title: 'Team mailboxes',
        items: [for (final account in _teamAccounts) _item(account)],
      ),
  ];
}

LinagoraAccountItem<String> _item(_DemoAccount account) => LinagoraAccountItem(
      id: account.id,
      name: account.name,
      email: account.email,
      avatar: _avatar(account.initials, 32),
    );

const _ownAccount = _DemoAccount(
  id: 'me',
  name: 'Nora Hale',
  email: 'nora.hale@example.com',
  initials: 'NH',
);

const _delegatedAccounts = [
  _DemoAccount(
    id: 'delegated-1',
    name: 'Mira Calder',
    email: 'mira.calder@example.com',
    initials: 'MC',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-2',
    name: 'Jessica Biel',
    email: 'jesssb@twake.app',
    initials: 'JB',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-3',
    name: 'Alex Rivera',
    email: 'alex.rivera@example.com',
    initials: 'AR',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-4',
    name: 'Sam Okonkwo',
    email: 'sam.okonkwo@example.com',
    initials: 'SO',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-5',
    name: 'Priya Shah',
    email: 'priya.shah@example.com',
    initials: 'PS',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-6',
    name: 'Jonah Berg',
    email: 'jonah.berg@example.com',
    initials: 'JB',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-7',
    name: 'Elena Vogt',
    email: 'elena.vogt@example.com',
    initials: 'EV',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-8',
    name: 'Chris Nguyen',
    email: 'chris.nguyen@example.com',
    initials: 'CN',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-9',
    name: 'Amelia Cole',
    email: 'amelia.cole@example.com',
    initials: 'AC',
    badgeLabel: 'Delegated mailbox',
  ),
  _DemoAccount(
    id: 'delegated-10',
    name: 'Diego Alvarez',
    email: 'diego.alvarez@example.com',
    initials: 'DA',
    badgeLabel: 'Delegated mailbox',
  ),
];

const _teamAccounts = [
  _DemoAccount(
    id: 'support',
    name: 'Support',
    email: 'support@twake.app',
    initials: 'SU',
    badgeLabel: 'Team mailbox',
  ),
  _DemoAccount(
    id: 'sales',
    name: 'Sales',
    email: 'sales@twake.app',
    initials: 'SA',
    badgeLabel: 'Team mailbox',
  ),
];

_DemoAccount _accountById(String id) {
  for (final account in [_ownAccount, ..._delegatedAccounts, ..._teamAccounts]) {
    if (account.id == id) return account;
  }
  return _ownAccount;
}

class _DemoAccount {
  final String id;
  final String name;
  final String email;
  final String initials;
  final String? badgeLabel;

  const _DemoAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.initials,
    this.badgeLabel,
  });
}

Widget _avatar(String initials, double size) => RoundAvatar(
      text: initials,
      size: size,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: size * 0.44,
        fontWeight: FontWeight.w600,
      ),
    );

Widget _statusBadge(bool isDark, String label) {
  final bg = isDark ? const Color(0x299BBEFA) : const Color(0x1A0A84FF);
  final fg = isDark ? const Color(0xFF9BBEFA) : const Color(0xFF0A84FF);
  return DecoratedBox(
    decoration: ShapeDecoration(color: bg, shape: const StadiumBorder()),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
        ),
      ),
    ),
  );
}

Color _surface(bool isDark) => isDark ? const Color(0xFF3F4249) : Colors.white;
