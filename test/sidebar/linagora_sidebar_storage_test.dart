import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  test(
    'requires a positive, finite storage progress height',
    _requiresPositiveFiniteProgressHeight,
  );
  test(
    'derives storage tokens for a legacy custom style',
    _legacyStorageTokens,
  );
  testWidgets('renders the quota specification', _quotaSpecification);
  testWidgets(
    'keeps the Figma storage typography in both themes',
    _storageTypography,
  );
  testWidgets('clamps invalid progress values', _clampsProgress);
  testWidgets(
    'maps storage states to semantic progress colours',
    _progressStates,
  );
  testWidgets(
    'lets callers override progress colours',
    _progressColorOverrides,
  );
  testWidgets('supports optional content and a custom icon', _optionalContent);
  testWidgets('sizes an oversized custom icon widget', _constrainsIconWidget);
  testWidgets('forwards a tap from the full storage block', _tap);
  testWidgets('names a tappable block exactly once', _tapSemantics);
  testWidgets('uses injected storage tokens', _injectedStyle);
  testWidgets(
    'uses injected progress state tokens instead of ambient brightness',
    _injectedProgressStateTokens,
  );
  testWidgets(
    'uses custom warning and full progress tokens',
    _customProgressStates,
  );
  testWidgets('does not overflow with long caller-provided content', _overflow);
}

void _requiresPositiveFiniteProgressHeight() {
  for (final height in [0.0, -1.0, double.infinity, double.nan]) {
    expect(
      () => _storageStyle(
        (
          progressHeight: height,
          foreground: _defaultStorageBase.foreground,
          activeForeground: _defaultStorageBase.activeForeground,
          selectedBackground: _defaultStorageBase.selectedBackground,
        ),
        _emptyProgressTokens,
        _emptyStorageTokens,
      ),
      throwsAssertionError,
      reason: '$height is not a valid progress height',
    );
  }
}

void _legacyStorageTokens() {
  const foreground = Color(0xFF123456);
  const active = Color(0xFF654321);
  const selected = Color(0xFFABCDEF);
  final style = _storageStyle(
    (
      progressHeight: _defaultStorageBase.progressHeight,
      foreground: foreground,
      activeForeground: active,
      selectedBackground: selected,
    ),
    _emptyProgressTokens,
    _emptyStorageTokens,
  );

  expect(style.progressHeight, 3);
  expect(style.resolvedStorageForeground, foreground.withValues(alpha: 0.64));
  expect(style.resolvedStorageIconForeground, foreground);
  expect(
    style.resolvedStorageVersionForeground,
    foreground.withValues(alpha: 0.64),
  );
  expect(style.resolvedProgressColor, active);
  expect(style.resolvedProgressTrackColor, selected);
  expect(
    style.resolvedProgressWarningColor,
    LinagoraSysColors.material().warning,
  );
  expect(style.resolvedProgressFullColor, LinagoraSysColors.material().error);
}

Future<void> _quotaSpecification(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarStorage(
      label: 'Storage',
      progress: 0.02,
      caption: '497.28 GB available',
    ),
  );

  final style = LinagoraSidebarStyle.light();
  final progress = tester.widget<LinearProgressIndicator>(
    find.byType(LinearProgressIndicator),
  );

  expect(tester.getSize(find.byIcon(Icons.cloud_outlined)), const Size(24, 24));
  expect(progress.value, 0.02);
  expect(progress.minHeight, style.progressHeight);
  expect(progress.color, style.resolvedProgressColor);
  expect(progress.backgroundColor, style.resolvedProgressTrackColor);
  _expectStorageTypography(tester.widget<Text>(find.text('Storage')).style);
  _expectStorageTypography(
    tester.widget<Text>(find.text('497.28 GB available')).style,
  );
  expect(
    tester.widget<Icon>(find.byIcon(Icons.cloud_outlined)).color,
    style.resolvedStorageIconForeground,
  );
}

Future<void> _storageTypography(WidgetTester tester) async {
  for (final brightness in Brightness.values) {
    await pumpSidebar(
      tester,
      const LinagoraSidebarStorage(
        label: 'Storage',
        progress: 0.02,
        caption: '497.28 GB available',
      ),
      surface: SidebarSurface(brightness: brightness),
    );

    final style = brightness == Brightness.dark
        ? LinagoraSidebarStyle.dark()
        : LinagoraSidebarStyle.light();
    final label = tester.widget<Text>(find.text('Storage'));
    final caption = tester.widget<Text>(find.text('497.28 GB available'));

    _expectStorageTypography(label.style);
    _expectStorageTypography(caption.style);
    expect(label.style?.color, style.resolvedStorageForeground);
    expect(caption.style?.color, style.resolvedStorageForeground);
  }
}

void _expectStorageTypography(TextStyle? style) {
  expect(style?.fontSize, 12);
  expect(style?.fontWeight, FontWeight.w500);
  expect(style?.height, 15.76 / 12);
  expect(style?.letterSpacing, 0.5);
}

Future<void> _clampsProgress(WidgetTester tester) async {
  Future<void> expectValue(double input, double expected) async {
    await pumpSidebar(
      tester,
      LinagoraSidebarStorage(label: 'Storage', progress: input),
    );

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      expected,
    );
    expect(tester.takeException(), isNull);
  }

  await expectValue(-1, 0);
  await expectValue(1.7, 1);
  // A host dividing by a zero or unknown total must not read as a full quota.
  await expectValue(double.nan, 0);
  await expectValue(double.infinity, 1);
  await expectValue(double.negativeInfinity, 0);
}

Future<void> _progressStates(WidgetTester tester) async {
  Future<Color?> colorFor(
    LinagoraSidebarStorageProgressState state, {
    Brightness brightness = Brightness.light,
  }) async {
    await pumpSidebar(
      tester,
      LinagoraSidebarStorage(
        label: 'Storage',
        progress: 0.5,
        progressState: state,
      ),
      surface: SidebarSurface(brightness: brightness),
    );
    expect(
      Theme.of(tester.element(find.byType(LinagoraSidebarStorage))).brightness,
      brightness,
    );
    return tester
        .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
        .color;
  }

  final colors = LinagoraSysColors.material();
  expect(
    await colorFor(LinagoraSidebarStorageProgressState.normal),
    LinagoraSidebarStyle.light().resolvedProgressColor,
  );
  expect(
    await colorFor(LinagoraSidebarStorageProgressState.warning),
    colors.warning,
  );
  expect(
    await colorFor(LinagoraSidebarStorageProgressState.full),
    colors.error,
  );
  expect(
    await colorFor(
      LinagoraSidebarStorageProgressState.normal,
      brightness: Brightness.dark,
    ),
    LinagoraSidebarStyle.dark().resolvedProgressColor,
  );
  expect(
    await colorFor(
      LinagoraSidebarStorageProgressState.full,
      brightness: Brightness.dark,
    ),
    colors.errorDark,
  );
  // No dedicated dark warning token exists yet, so the amber carries over.
  // Pinned here so introducing one has to update this expectation knowingly.
  expect(
    await colorFor(
      LinagoraSidebarStorageProgressState.warning,
      brightness: Brightness.dark,
    ),
    colors.warningDark,
  );
  expect(colors.warningDark, colors.warning);
}

Future<void> _progressColorOverrides(WidgetTester tester) async {
  const fill = Color(0xFF123456);
  const track = Color(0xFF654321);
  final style = LinagoraSidebarStyle.light();

  Future<void> expectColours({Color? progressColor, Color? trackColor}) async {
    await pumpSidebar(
      tester,
      LinagoraSidebarStorage(
        label: 'Storage',
        progress: 1,
        progressState: LinagoraSidebarStorageProgressState.full,
        progressColor: progressColor,
        progressTrackColor: trackColor,
      ),
    );

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.color, progressColor ?? style.resolvedProgressFullColor);
    expect(
      indicator.backgroundColor,
      trackColor ?? style.resolvedProgressTrackColor,
    );
  }

  await expectColours(progressColor: fill);
  await expectColours(trackColor: track);
  await expectColours(progressColor: fill, trackColor: track);
}

Future<void> _optionalContent(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarStorage(
      label: 'Storage',
      progress: 0.5,
      iconWidget: FlutterLogo(size: LinagoraSidebarStorage.iconSize),
    ),
  );

  expect(find.byType(FlutterLogo), findsOneWidget);
  expect(find.byIcon(Icons.cloud_outlined), findsNothing);
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
}

/// A product asset does not read [IconTheme], so the slot has to size it or an
/// oversized SVG pushes the footer apart.
Future<void> _constrainsIconWidget(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarStorage(
      label: 'Storage',
      progress: 0.5,
      iconWidget: FlutterLogo(size: 96),
    ),
  );

  expect(
    tester.getSize(find.byType(FlutterLogo)),
    const Size.square(LinagoraSidebarStorage.iconSize),
  );
  expect(tester.takeException(), isNull);
}

Future<void> _tap(WidgetTester tester) async {
  var taps = 0;
  await pumpSidebar(
    tester,
    LinagoraSidebarStorage(
      label: 'Storage',
      progress: 0.5,
      onTap: () => taps++,
    ),
  );

  await tester.tap(find.text('Storage'));

  expect(taps, 1);
}

/// The block's own text names it. An explicit Semantics label on the wrapper
/// merged with that text and made a screen reader read the title twice.
Future<void> _tapSemantics(WidgetTester tester) async {
  final handle = tester.ensureSemantics();
  try {
    await pumpSidebar(
      tester,
      LinagoraSidebarStorage(
        label: 'Storage',
        progress: 0.5,
        caption: '10 GB free',
        onTap: () {},
      ),
    );

    final node = tester.getSemantics(find.byType(LinagoraSidebarStorage));
    expect(node.label, 'Storage\n10 GB free');
    expect(node.value, '50%');
    expect(
      node.flagsCollection.isButton,
      isTrue,
      reason: 'the tappable block keeps its button role',
    );
  } finally {
    handle.dispose();
  }
}

Future<void> _injectedStyle(WidgetTester tester) async {
  const foreground = Color(0xFF123456);
  const icon = Color(0xFF654321);
  const progress = Color(0xFFABCDEF);
  const warning = Color(0xFFBA55D3);
  const full = Color(0xFFCD5C5C);
  const track = Color(0xFFFEDCBA);
  final style = _storageStyle(
    (
      progressHeight: 5,
      foreground: foreground,
      activeForeground: null,
      selectedBackground: Colors.transparent,
    ),
    (color: progress, warning: warning, full: full, track: track),
    (foreground: foreground, iconForeground: icon, versionForeground: null),
  );
  await pumpSidebar(
    tester,
    LinagoraSidebarStorage(label: 'Storage', progress: 0.5, style: style),
  );

  final indicator = tester.widget<LinearProgressIndicator>(
    find.byType(LinearProgressIndicator),
  );
  expect(indicator.minHeight, 5);
  expect(indicator.color, progress);
  expect(indicator.backgroundColor, track);
  expect(tester.widget<Text>(find.text('Storage')).style?.color, foreground);
  expect(tester.widget<Icon>(find.byIcon(Icons.cloud_outlined)).color, icon);
}

Future<void> _injectedProgressStateTokens(WidgetTester tester) async {
  final style = LinagoraSidebarStyle.dark();
  await pumpSidebar(
    tester,
    LinagoraSidebarStorage(
      label: 'Storage',
      progress: 1,
      progressState: LinagoraSidebarStorageProgressState.full,
      style: style,
    ),
  );

  final indicator = tester.widget<LinearProgressIndicator>(
    find.byType(LinearProgressIndicator),
  );
  expect(indicator.color, style.resolvedProgressFullColor);
  expect(indicator.color, LinagoraSysColors.material().errorDark);
}

Future<void> _customProgressStates(WidgetTester tester) async {
  const normal = Color(0xFF123456);
  const warning = Color(0xFF654321);
  const full = Color(0xFFABCDEF);
  final style = _storageStyle(_defaultStorageBase, (
    color: normal,
    warning: warning,
    full: full,
    track: null,
  ), _emptyStorageTokens);

  for (final stateAndColor in [
    (state: LinagoraSidebarStorageProgressState.warning, color: warning),
    (state: LinagoraSidebarStorageProgressState.full, color: full),
  ]) {
    await pumpSidebar(
      tester,
      LinagoraSidebarStorage(
        label: 'Storage',
        progress: 0.5,
        progressState: stateAndColor.state,
        style: style,
      ),
      surface: const SidebarSurface(brightness: Brightness.dark),
    );

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .color,
      stateAndColor.color,
    );
  }
}

Future<void> _overflow(WidgetTester tester) async {
  await pumpSidebar(
    tester,
    const LinagoraSidebarStorage(
      label: 'A storage label that is far too long for the sidebar footer',
      progress: 0.5,
      caption: 'A quota caption that is far too long for the sidebar footer',
    ),
  );

  expect(tester.takeException(), isNull);
}

LinagoraSidebarStyle _storageStyle(
  _StorageStyleBase base,
  _ProgressTokens progress,
  _StorageTokens storage,
) {
  return LinagoraSidebarStyle(
    itemMinHeight: 36,
    itemBorderRadius: 8,
    itemIconSize: 16,
    itemHorizontalPadding: 8,
    chevronSize: 10,
    itemSpacing: 8,
    hoverBackground: Colors.transparent,
    selectedBackground: base.selectedBackground,
    badgeBackground: Colors.transparent,
    badgeHeight: 16,
    badgeHorizontalPadding: 6,
    badgeForeground: base.foreground,
    foreground: base.foreground,
    activeForeground: base.activeForeground ?? base.foreground,
    trailingForeground: base.foreground,
    labelTextStyle: const TextStyle(),
    badgeTextStyle: const TextStyle(),
    progressHeight: base.progressHeight,
    storageForeground: storage.foreground,
    storageIconForeground: storage.iconForeground,
    storageVersionForeground: storage.versionForeground,
    progressColor: progress.color,
    progressWarningColor: progress.warning,
    progressFullColor: progress.full,
    progressTrackColor: progress.track,
  );
}

typedef _StorageStyleBase = ({
  double progressHeight,
  Color foreground,
  Color? activeForeground,
  Color selectedBackground,
});

typedef _ProgressTokens = ({
  Color? color,
  Color? warning,
  Color? full,
  Color? track,
});

typedef _StorageTokens = ({
  Color? foreground,
  Color? iconForeground,
  Color? versionForeground,
});

const _StorageStyleBase _defaultStorageBase = (
  progressHeight: 3,
  foreground: Color(0xFF123456),
  activeForeground: null,
  selectedBackground: Colors.transparent,
);

const _ProgressTokens _emptyProgressTokens = (
  color: null,
  warning: null,
  full: null,
  track: null,
);

const _StorageTokens _emptyStorageTokens = (
  foreground: null,
  iconForeground: null,
  versionForeground: null,
);
