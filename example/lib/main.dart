import 'package:example/demos/circle_avatar_example.dart';
import 'package:example/demos/circle_avatar_load_from_memory_example.dart';
import 'package:example/demos/image_picker_bottom_sheet_example.dart';
import 'package:example/demos/image_picker_example.dart';
import 'package:example/demos/list_item_demo.dart';
import 'package:example/demos/multiple_account_picker_example.dart';
import 'package:example/demos/permission_handler.dart';
import 'package:example/demos/reaction_demo.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/dialog/confirmation_dialog_builder.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linagora Design Component Examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Examples'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const DemoTile(
            component: CircleAvatarExample(),
            title: 'Demo CircleAvatar component',
          ),
          const SizedBox(height: 20),
          DemoTile(
              title: 'Demo CircleAvatar component with load image from bytes',
              component: CircleAvatarLoadFromMemoryExample()),
          const SizedBox(height: 20),
          DemoTile(
              title: 'Demo Image picker',
              onPressed: () async {
                final permission = await PermissionHandlerService()
                    .getCurrentPermission(PermissionType.photos);
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImagesPickerExample(
                            permissionStatus: permission,
                          )),
                );
              }),
          const SizedBox(height: 20),
          DemoTile(
              title: "Demo Image picker with bottom sheet",
              onPressed: () async {
                final permission = await PermissionHandlerService()
                    .getCurrentPermission(PermissionType.photos);
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImagePickerBottomSheetExample(
                            permissionStatus: permission,
                          )),
                );
              }),
          const SizedBox(height: 20),
          DemoTile(
              title: "Demo homeserver screen",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TwakeWelcomeScreen(
                      signInTitle: 'Sign in',
                      createTwakeIdTitle: 'Create a Twake ID',
                      useCompanyServerTitle: 'Use your company server',
                      description:
                          'To start, please create a TwakeID \nthat will allow you to use \nchat, mail and drive',
                      privacyPolicy: 'Privacy Policy',
                      descriptionPrivacyPolicy:
                          'By continuing, you\'r agreeing to our',
                    ),
                  ),
                );
              }),
          const SizedBox(height: 20),
          DemoTile(
              title: "Demo multiple account with bottom sheet",
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MultipleAccountPickerExample(),
                  ),
                );
              }),
          const SizedBox(height: 20),
          DemoTile(
              title: "Demo ListView item",
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListItemExample(),
                  ),
                );
              }),
          const SizedBox(height: 20),
          DemoTile(
              title: "Demo reaction",
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReactionScreen(),
                  ),
                );
              }),
          DemoTile(
            title: "Confirmation dialog reaction",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmationDialogBuilder(
                    title: 'Title',
                    textContent: 'Description',
                    confirmText: 'Confirm',
                    cancelText: 'Cancel',
                    onConfirmButtonAction: () {
                      Navigator.pop(context);
                    },
                    onCancelButtonAction: () {
                      Navigator.pop(context);
                    },
                    onCloseButtonAction: () {
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class DemoTile extends StatelessWidget {
  final String title;

  final Widget? component;

  final Function()? onPressed;

  const DemoTile({
    super.key,
    required this.title,
    this.component,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => component ?? const SizedBox()),
            );
          },
      style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size(100, 50))),
      child: Text(title),
    );
  }
}
