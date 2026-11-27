import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  const description = 'Безопасный мессенджер\nна основе протокола Matrix';
  const createTwakeId = 'Создать Twake ID';
  const signIn = 'Войти';
  const companyServer = 'Корпоративный сервер';
  const privacyPolicy = 'Политику конфиденциальности';

  Future<List<String>> pumpWelcomeScreen(
    WidgetTester tester, {
    required Size size,
    required double textScale,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final taps = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: TwakeWelcomeScreen(
          logo: const SizedBox(width: 225, height: 147),
          description: description,
          createTwakeIdTitle: createTwakeId,
          signInTitle: signIn,
          useCompanyServerTitle: companyServer,
          descriptionPrivacyPolicy: 'Продолжая, вы принимаете',
          privacyPolicy: privacyPolicy,
          onCreateTwakeIdOnTap: () => taps.add(createTwakeId),
          onSignInOnTap: () => taps.add(signIn),
          onUseCompanyServerOnTap: () => taps.add(companyServer),
          onPrivacyPolicyOnTap: () => taps.add(privacyPolicy),
        ),
      ),
    );
    return taps;
  }

  for (final (name, size, textScale) in [
    ('small phone with large text', const Size(360, 640), 1.3),
    ('very small phone with huge text', const Size(320, 480), 2.0),
    ('regular phone', const Size(393, 852), 1.0),
  ]) {
    testWidgets('$name: buttons never cover the description', (tester) async {
      await pumpWelcomeScreen(tester, size: size, textScale: textScale);

      expect(tester.takeException(), isNull);
      expect(
        tester.getRect(find.text(description)).bottom,
        lessThanOrEqualTo(tester.getRect(find.text(createTwakeId)).top),
      );
    });

    testWidgets('$name: every action receives its tap', (tester) async {
      final taps = await pumpWelcomeScreen(
        tester,
        size: size,
        textScale: textScale,
      );

      for (final label in [
        createTwakeId,
        signIn,
        companyServer,
        privacyPolicy,
      ]) {
        await tester.ensureVisible(find.text(label));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label));
      }

      expect(taps, [createTwakeId, signIn, companyServer, privacyPolicy]);
    });
  }
}
