## 0.3.3

### Added

* Complete the Event Invitation Card UI and public API (`LinagoraEventCard`)
  with adaptive, regular and compact layouts; optional date, activity and
  title sections; labelled and expandable event details; conflict and status
  indicators; attendee RSVP controls; and more-information, secondary and
  calendar actions.
* Add `EventActivityBadge` for created, reminder, updated, accepted,
  cancelled and not-invited event states.
* Add `EventConferenceActions` with independently configurable
  video-conference join and copy-link controls.
* Add configurable `padding` and `shape` to `LinagoraIconButton` for custom
  icon-button action designs.
* Add Event Card, event activity badge, conference action and event info-row
  use cases to Widgetbook.
* `LinagoraAlert`: a rounded, accent-tinted notice with a leading icon, an
  optional title, a message, and any combination of a primary action, a
  secondary action, a dismiss control, and a callout pointer. Five severities
  (`primary`, `secondary`, `error`, `warning`, `success`), two container
  treatments (`standard`, `filled`), two vertical rhythms (`normal`,
  `compact`), three action alignments and two text alignments.
* `LinagoraAlertPalette`: resolves a severity to its accent, container tint,
  text and dismiss colours, so a product can tint a neighbouring surface to
  match the alert beside it.
* `LinagoraAlertPointer`: the callout tail, reusable on a product's own
  surface.
* `LinagoraTypography`: the shared product type scale, available as a theme
  extension with configurable heading, body, button and caption variants.

### Changed

* Preserve explicitly configured `LinagoraButton` heights when desktop visual
  density is active.
* Make all predefined viewports available in Widgetbook.

### Fixed

* Allow localized month abbreviations of any non-blank length in event date
  markers, scaling longer labels down to fit.
* Make expanded event information rows shrink-wrap safely when their available
  width is unbounded.

## 0.3.2

### Changed

* Sidebar accordion/expand chevron token (`LinagoraSidebarStyle.chevronSize`)
  is 16, matching Teammail folder-row Figma.

### Fixed

* Cozy external bridge script now falls back to its pre-1.x bundle path
  (`dist/embedded/bundle.js`) when the 1.x path (`dist/bundle.js`) fails to
  load, and the default pinned version reverts to `0.16.1`.

## 0.3.1 - 2026-08-25

### Fixed

* Sidebar tree items at deep nesting levels now remain visible and keep their
  expand/collapse controls accessible.
* Sidebar tree expand/collapse chevrons now stay aligned with their labels at
  every indentation level.

## 0.3.0 - 2026-08-20

### Added

* Sidebar menu system: `LinagoraSidebarMenu`, `LinagoraSidebarItem`,
  `LinagoraSidebarSubItem`, `LinagoraSidebarSectionHeader`,
  `LinagoraSidebarPrimaryAction`, `LinagoraSidebarFooter`,
  `LinagoraSidebarStorage` and `LinagoraSidebarVersion` for composing a
  navigation sidebar with pinned header and footer regions.
* `LinagoraSidebarBadge`: counter pill capped at the width of `999+`, plus
  row support for leading icons/widgets, expand/collapse, hover-revealed
  trailing content, drag targets, and application-owned active/expanded/
  enabled state.
* Virtualized sidebar tree lists, grouped tree lists, tree flattening and
  drag auto-scroll utilities for large and nested navigation collections.
* Sidebar action APIs: `LinagoraSidebarItemActions`,
  `LinagoraSidebarMenuAction`, `LinagoraSidebarPopoverAction` and
  `LinagoraSidebarConfirmPopover`.
* `LinagoraSidebarStyle` and `LinagoraSidebarTheme`: brightness-aware sidebar
  design tokens with immutable item, section, storage and popover overrides.
* `LinagoraButtonVariant.text`: renders a `TextButton`. Existing exhaustive
  switches over the enum need a new branch.
* `LinagoraIconButton`: `tapTargetSize` and `visualDensity`.

### Changed

* Raised the minimum supported Flutter SDK to 3.38.0 for
  `OverlayChildLocation`, used by sidebar popover actions.

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
