import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: TwakeWelcomeScreen)
Widget twakeWelcomeScreenUseCase(BuildContext context) {
  final textScale = context.knobs.double.slider(
    label: 'Text scale',
    initialValue: 1,
    min: 1,
    max: 2,
    divisions: 10,
  );
  final showSignUp = context.knobs.boolean(
    label: 'Sign up and sign in buttons',
    initialValue: true,
  );

  return MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: TwakeWelcomeScreen(
      logo: const Padding(
        padding: EdgeInsets.only(bottom: 32),
        child: FlutterLogo(size: 147),
      ),
      description: context.knobs.string(
        label: 'Description',
        initialValue: 'An open source messenger encrypt\n'
            'your data with matrix protocol',
      ),
      createTwakeIdTitle: showSignUp ? 'Create Twake ID' : null,
      signInTitle: showSignUp ? 'Sign in' : null,
      useCompanyServerTitle: 'Use your company server',
      descriptionPrivacyPolicy: "By continuing, you're agreeing to our",
      privacyPolicy: 'Privacy Policy',
      onCreateTwakeIdOnTap: () {},
      onSignInOnTap: () {},
      onUseCompanyServerOnTap: () {},
      onPrivacyPolicyOnTap: () {},
    ),
  );
}
