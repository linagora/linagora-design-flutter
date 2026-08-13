## Unreleased

### Added

* `LinagoraSidebarItem`: left-menu navigation row with leading icon or widget,
  count badge, expand/collapse chevron, hover-revealed trailing slot, and
  application-owned `active`, `expanded` and `enabled` state.
* `LinagoraSidebarBadge`: counter pill capped at the width of `999+`.
* `LinagoraSidebarStyle`: sidebar design tokens, resolved from the ambient
  theme brightness, overridable per widget.
* `LinagoraButtonVariant.text`: renders a `TextButton`. Existing exhaustive
  switches over the enum need a new branch.
* `LinagoraIconButton`: `tapTargetSize` and `visualDensity`.

### Fixed

* Widgetbook: add the missing `LinagoraSettingItem` use case file, which
  `widgetbook.dart` already imported and called.

## 0.2.7 - 2026-08-11

### Removed

* `TwakeInter.ttf`: dropped unweighted/redundant font asset from
  `assets/fonts/` and `pubspec.yaml`; weight 400 now resolves solely from
  `TwakeInter-Regular.ttf`.

## 0.2.6 - 2026-07-31

### Added

* `LinagoraSettingItem`: settings row with leading icon, title/subtitle,
  trailing chevron/spinner, optional divider, hover/pressed background,
  matching Figma "Setting item" (node 58604:6126, states 58604:6124/6125).

## 0.2.5 - 2026-07-31

### Added

* `LinagoraTextField`: `autofocus`, `onSubmitted`, `textInputAction`,
  `focusNode` and `keyboardType` for keyboard-driven submit and external
  focus control.

## 0.2.4 - 2026-07-29

### Changed

* `SessionDeviceListItem`: constrain trailing button width.

## 0.2.3 - 2026-07-28

### Added

* `LinagoraBanner`: dismissible banner widget with title, description, action
  and leading icon.
* `LinagoraTextField`: text field component with variants, validation states
  and `InputDecorationMerge` extension for flexible `InputDecoration`
  overrides.
* `LinagoraIconButton`: icon button with overlay color and padding support.
* `SessionDeviceListItem` and `SessionDeviceAvatar`: list item components for
  displaying session/device info.

## 0.2.2 - 2026-07-24

### Added

* `WebLinkGenerator`: utility for generating web links.

## 0.2.1 - 2026-07-24

### Added

* `LinagoraTextStyle.titleSmall2` (15px · Medium) and
  `LinagoraTextStyle.bodyMedium4` (15px · Regular), imported from the Figma
  tokens `M3/title/small2` and `M3/body/Medium4`.
* `LinagoraTextThemeExtension.titleSmall2` and
  `LinagoraTextThemeExtension.bodyMedium4` exposing the new tokens.

## 0.2.0 - 2026-06-22

### Added
* `LinagoraTextTheme` / `LinagoraTextThemeExtension`: design-system `TextTheme`
  derived from `LinagoraTextStyle`

### Removed
* `LinagoraFonts` — reaplaced by `LinagoraTextTheme`

## 0.1.1 - 2026-06-16

### Added

* `RightClickFocus`: Gives [focusNode] focus when its subtree receives a secondary (right) mouse button press, web only.

## 0.1.0 - 2026-06-08

### Added

* `MessageBubble`: rounded chat bubble with optional tail, content-type aware
  padding (`BubbleContentType`), reactions spacing and a custom `BubbleShape`.
* `LinagoraButton`: `filled`/`outlined` variants and `xs`/`m` sizes.
* `LinagoraSpacing`: base spacing scale.
* `LinagoraTextStyle`: expanded typography scale with documented size/weight per
  style.
* 
### Changed

* Support Flutter 3.32.8.

## 0.0.1

* Initial release.
