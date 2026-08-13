import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

import 'linagora_sidebar_test_utils.dart';

void main() {
  testWidgets('renders the quota specification', _quotaSpecification);
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
  testWidgets('does not overflow with long caller-provided content', _overflow);
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
  expect(tester.widget<Text>(find.text('Storage')).style?.fontSize, 12);
  expect(
    tester.widget<Icon>(find.byIcon(Icons.cloud_outlined)).color,
    style.resolvedStorageIconForeground,
  );
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
  await pumpSidebar(
    tester,
    const LinagoraSidebarStorage(
      label: 'Storage',
      progress: 1,
      progressState: LinagoraSidebarStorageProgressState.full,
      progressColor: fill,
      progressTrackColor: track,
    ),
  );

  final indicator = tester.widget<LinearProgressIndicator>(
    find.byType(LinearProgressIndicator),
  );
  expect(indicator.color, fill);
  expect(indicator.backgroundColor, track);
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
  const style = LinagoraSidebarStyle(
    itemMinHeight: 36,
    itemBorderRadius: 8,
    itemIconSize: 16,
    itemHorizontalPadding: 8,
    chevronSize: 10,
    itemSpacing: 8,
    hoverBackground: Colors.transparent,
    selectedBackground: Colors.transparent,
    badgeBackground: Colors.transparent,
    badgeHeight: 16,
    badgeHorizontalPadding: 6,
    badgeForeground: foreground,
    foreground: foreground,
    activeForeground: foreground,
    trailingForeground: foreground,
    labelTextStyle: TextStyle(),
    badgeTextStyle: TextStyle(),
    progressHeight: 5,
    storageForeground: foreground,
    storageIconForeground: icon,
    progressColor: progress,
    progressWarningColor: warning,
    progressFullColor: full,
    progressTrackColor: track,
  );
  await pumpSidebar(
    tester,
    const LinagoraSidebarStorage(label: 'Storage', progress: 0.5, style: style),
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
