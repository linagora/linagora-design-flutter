import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';
import 'package:linagora_design_flutter/multiple_account/models/twake_presentation_account.dart';

class TwakePresentationAccountExample extends TwakePresentationAccount {
  const TwakePresentationAccountExample({
    required String accountName,
    required String accountId,
    required Widget avatar,
    required AccountActiveStatus accountActiveStatus,
  }) : super(
          accountName: accountName,
          accountId: accountId,
          avatar: avatar,
          accountActiveStatus: accountActiveStatus,
        );
}

class MultipleAccountPickerExample extends StatefulWidget {
  const MultipleAccountPickerExample({super.key});

  @override
  State<MultipleAccountPickerExample> createState() =>
      _MultipleAccountPickerExampleState();
}

class _MultipleAccountPickerExampleState
    extends State<MultipleAccountPickerExample> {
  final List<TwakePresentationAccount> accounts = [
    const TwakePresentationAccountExample(
      accountName: "Alice Alice Alice Alice Alice Alice Alice Alice",
      accountId: "@alice.domain.xyz",
      accountActiveStatus: AccountActiveStatus.active,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("Alice"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "BoB",
      accountId: "@bob.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("BoB"),
      ),
    ),
    const TwakePresentationAccountExample(
      accountName: "ToM",
      accountId: "@tom.domain.xyz",
      accountActiveStatus: AccountActiveStatus.inactive,
      avatar: CircleAvatar(
        radius: 24,
        child: Text("ToM"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multiple Account"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => MultipleAccountPicker.showMultipleAccountPicker(
            accounts: accounts,
            context: context,
            onAddAnotherAccount: () {},
            onGoToAccountSettings: () {},
            onSetAccountAsActive: (_) {},
            titleAddAnotherAccount: 'Add another account',
            titleAccountSettings: 'Account settings',
            titleAccountSettingsStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: LinagoraSysColors.material().primary,
            ),
            addAnotherAccountStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: LinagoraSysColors.material().onPrimary,
            ),
            accountIdStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: LinagoraRefColors.material().tertiary[20],
            ),
            accountNameStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: LinagoraSysColors.material().onSurface,
            ),
            logoApp: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/images/logo_twake_chat.png',
                width: 151,
                height: 28,
              ),
            ),
          ),
          child: const Text("Open multiple account"),
        ),
      ),
    );
  }
}
