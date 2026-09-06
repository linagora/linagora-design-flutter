import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  testWidgets(
    'matches the default video button and copy icon button specification',
    _matchesDefaultSpecification,
  );
  testWidgets('shows each action independently', _showsActionsIndependently);
  testWidgets('disables actions without callbacks', _disablesActions);
  testWidgets('uses the video icon size for IconData', _usesVideoIconDataSize);
  testWidgets(
    'prefers the custom video icon widget and applies its size',
    _usesCustomVideoIconWidget,
  );
  testWidgets(
    'supports custom copy icons, widgets, and sizes',
    _supportsCustomCopyIcons,
  );
  testWidgets(
    'lets caller video style values override defaults',
    _overridesDefaultVideoStyle,
  );
  testWidgets('invokes the visible action callbacks', _invokesCallbacks);
  testWidgets(
    'fits a long label on a phone-width row',
    _fitsALongLabelOnAPhone,
  );
  test('rejects non-positive icon sizes', _rejectsNonPositiveIconSizes);
}

Future<void> _matchesDefaultSpecification(WidgetTester tester) async {
  await _pump(
    tester,
    const EventConferenceActions(
      onVideoButtonPressed: _noop,
      onCopyLinkPressed: _noop,
    ),
  );

  final videoButton = find.byType(FilledButton);
  final copyButton = find.byType(IconButton);

  _expectDefaultVideoSpecification(tester, videoButton);
  _expectDefaultCopySpecification(tester, copyButton);
  expect(
    tester.getRect(copyButton).left - tester.getRect(videoButton).right,
    closeTo(EventConferenceActions.defaultActionGap, 0.01),
  );
}

void _expectDefaultVideoSpecification(WidgetTester tester, Finder videoButton) {
  final style = tester.widget<FilledButton>(videoButton).style!;
  final shape = style.shape!.resolve({})! as RoundedRectangleBorder;
  final icon = find.descendant(
    of: videoButton,
    matching: find.byType(SvgPicture),
  );
  final loader = tester.widget<SvgPicture>(icon).bytesLoader as SvgAssetLoader;

  expect(tester.getSize(videoButton).height, 40);
  expect(
    style.padding!.resolve({}),
    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );
  expect(
    style.backgroundColor!.resolve({}),
    EventConferenceActions.defaultVideoButtonBackground,
  );
  expect(
    style.foregroundColor!.resolve({}),
    EventConferenceActions.defaultVideoButtonForeground,
  );
  expect(style.iconSize!.resolve({}), 24);
  expect(shape.borderRadius, const BorderRadius.all(Radius.circular(4)));
  expect(style.textStyle!.resolve({}), LinagoraTextTheme.material().labelLarge);
  expect(tester.getSize(icon), const Size.square(24));
  expect(loader.assetName, LinagoraDesignImages.videoConferenceIcon);
  expect(loader.packageName, LinagoraDesignImages.packageName);
}

void _expectDefaultCopySpecification(WidgetTester tester, Finder copyButton) {
  final button = tester.widget<IconButton>(copyButton);
  final icon = find.descendant(
    of: copyButton,
    matching: find.byType(SvgPicture),
  );

  expect(tester.getSize(copyButton), const Size.square(40));
  expect(tester.getSize(icon), const Size.square(24));
  expect(find.byTooltip('Copy link'), findsOneWidget);
  expect(button.padding, EventConferenceActions.defaultCopyButtonPadding);
  expect(button.visualDensity, VisualDensity.standard);
  expect(button.style!.shape!.resolve({}), isA<CircleBorder>());
  _expectCopyPressedStateLayer(tester, copyButton);
}

void _expectCopyPressedStateLayer(WidgetTester tester, Finder copyButton) {
  final style = tester.widget<IconButton>(copyButton).style!;

  expect(
    style.overlayColor!.resolve({WidgetState.pressed}),
    EventConferenceActions.defaultCopyOverlayColor.withAlpha(26),
  );
}

Future<void> _showsActionsIndependently(WidgetTester tester) async {
  await _pump(
    tester,
    const EventConferenceActions(
      showVideoButton: false,
      onCopyLinkPressed: _noop,
    ),
  );
  expect(find.byType(FilledButton), findsNothing);
  expect(find.byType(IconButton), findsOneWidget);

  await _pump(
    tester,
    const EventConferenceActions(
      showCopyButton: false,
      onVideoButtonPressed: _noop,
    ),
  );
  expect(find.byType(FilledButton), findsOneWidget);
  expect(find.byType(IconButton), findsNothing);

  await _pump(
    tester,
    const EventConferenceActions(showVideoButton: false, showCopyButton: false),
  );
  expect(find.byType(FilledButton), findsNothing);
  expect(find.byType(IconButton), findsNothing);
}

Future<void> _disablesActions(WidgetTester tester) async {
  await _pump(tester, const EventConferenceActions());

  final videoButton = tester.widget<FilledButton>(find.byType(FilledButton));
  final copyButton = tester.widget<IconButton>(find.byType(IconButton));

  expect(videoButton.onPressed, isNull);
  expect(copyButton.onPressed, isNull);

  await _pump(
    tester,
    const EventConferenceActions(
      showVideoButton: false,
      copyButtonTooltip: null,
    ),
  );
  expect(find.byTooltip('Copy link'), findsNothing);
}

Future<void> _usesVideoIconDataSize(WidgetTester tester) async {
  await _pump(
    tester,
    const EventConferenceActions(
      showCopyButton: false,
      videoIcon: Icons.videocam,
      videoIconSize: 32,
      onVideoButtonPressed: _noop,
    ),
  );

  final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;

  expect(style.iconSize!.resolve({}), 32);
  expect(tester.getSize(find.byIcon(Icons.videocam)), const Size.square(32));
}

Future<void> _usesCustomVideoIconWidget(WidgetTester tester) async {
  const customIconKey = Key('custom-video-icon');
  await _pump(
    tester,
    const EventConferenceActions(
      showCopyButton: false,
      videoIcon: Icons.videocam,
      videoIconWidget: SizedBox(key: customIconKey),
      videoIconSize: 28,
      onVideoButtonPressed: _noop,
    ),
  );

  expect(find.byKey(customIconKey), findsOneWidget);
  expect(find.byIcon(Icons.videocam), findsNothing);
  expect(tester.getSize(find.byKey(customIconKey)), const Size.square(28));
}

Future<void> _supportsCustomCopyIcons(WidgetTester tester) async {
  await _pump(
    tester,
    const EventConferenceActions(
      showVideoButton: false,
      copyIcon: Icons.content_copy,
      copyIconSize: 28,
      copyIconColor: Colors.blue,
      onCopyLinkPressed: _noop,
    ),
  );

  final copyButton = tester.widget<IconButton>(find.byType(IconButton));
  expect(copyButton.iconSize, 28);
  expect(copyButton.color, Colors.blue);
  expect(
    tester.getSize(find.byIcon(Icons.content_copy)),
    const Size.square(28),
  );

  const customIconKey = Key('custom-copy-icon');
  await _pump(
    tester,
    const EventConferenceActions(
      showVideoButton: false,
      copyIcon: Icons.content_copy,
      copyIconWidget: SizedBox(key: customIconKey),
      copyIconSize: 32,
      onCopyLinkPressed: _noop,
    ),
  );
  expect(find.byKey(customIconKey), findsOneWidget);
  expect(find.byIcon(Icons.content_copy), findsNothing);
  expect(tester.getSize(find.byKey(customIconKey)), const Size.square(32));
}

Future<void> _overridesDefaultVideoStyle(WidgetTester tester) async {
  await _pump(
    tester,
    const EventConferenceActions(
      showCopyButton: false,
      onVideoButtonPressed: _noop,
      videoButtonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.indigo),
        foregroundColor: WidgetStatePropertyAll(Colors.amber),
      ),
    ),
  );

  final style = tester.widget<FilledButton>(find.byType(FilledButton)).style!;
  expect(style.backgroundColor!.resolve({}), Colors.indigo);
  expect(style.foregroundColor!.resolve({}), Colors.amber);
  expect(style.minimumSize!.resolve({}), const Size(0, 40));
}

Future<void> _invokesCallbacks(WidgetTester tester) async {
  var videoTapCount = 0;
  var copyTapCount = 0;
  await _pump(
    tester,
    EventConferenceActions(
      onVideoButtonPressed: () => videoTapCount++,
      onCopyLinkPressed: () => copyTapCount++,
    ),
  );

  await tester.tap(find.byType(FilledButton));
  await tester.tap(find.byType(IconButton));

  expect(videoTapCount, 1);
  expect(copyTapCount, 1);
}

Future<void> _fitsALongLabelOnAPhone(WidgetTester tester) async {
  const longLabel = 'Join the video conference that has a very long label '
      'because it has been localised into a wordier language';

  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 390,
            child: EventConferenceActions(videoButtonLabel: longLabel),
          ),
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(
    tester.getSize(find.byType(EventConferenceActions)).width,
    lessThanOrEqualTo(390),
  );
}

void _rejectsNonPositiveIconSizes() {
  expect(() => EventConferenceActions(videoIconSize: 0), throwsAssertionError);
  expect(() => EventConferenceActions(copyIconSize: -1), throwsAssertionError);
}

Future<void> _pump(WidgetTester tester, Widget actions) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: actions)),
    ),
  );
}

void _noop() {}
