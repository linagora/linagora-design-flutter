import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

class ListItemExample extends StatelessWidget {
  const ListItemExample({super.key});

  Widget titleWidget(String title) {
    return Text(
      title,
      style: LinagoraTextStyle.material().bodyLarge1,
    );
  }

  Widget subtitleWidget(String title) {
    return Text(
      title,
      style: LinagoraTextStyle.material().bodyMedium1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TwakeInkWell(
              child: TwakeListItem(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget("User1"),
                    subtitleWidget("sent you a message"),
                  ],
                ),
              ),
            ),
          ),
          TwakeInkWell(
            child: TwakeListItem(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget("User2"),
                    subtitleWidget("sent you a message")
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
