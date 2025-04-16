import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/reaction/hero_dialog_route.dart';
import 'package:linagora_design_flutter/reaction/reaction_dialog_widget.dart';

class Message {
  String id;
  String message;
  bool isMe;

  Message({
    required this.id,
    required this.message,
    required this.isMe,
  });

  // list of messages
  static List<Message> messages = [
    Message(
      id: '1',
      message: 'Hello',
      isMe: false,
    ),
    Message(
      id: '2',
      message: 'Hi',
      isMe: true,
    ),
    Message(
      id: '3',
      message: 'How are you?',
      isMe: false,
    ),
    Message(
      id: '4',
      message:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque quis magna tincidunt, lobortis magna sit amet, pellentesque ligula. Ut nec velit et elit condimentum aliquam. Donec in nunc a ligula tincidunt finibus. Proin bibendum sit amet urna non convallis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Maecenas eget tortor et ex gravida lacinia et a purus. In pretium urna sit amet nulla molestie, in porttitor quam luctus. Donec in justo non mauris consectetur consectetur. Nunc blandit dictum sapien varius sollicitudin. Phasellus egestas, massa quis viverra imperdiet, eros ante venenatis enim, eget faucibus neque sem ut odio. Vivamus nec eros vel dolor mollis iaculis. Mauris imperdiet placerat lacus ut blandit. Ut eleifend porttitor lorem, a egestas eros. Praesent efficitur, turpis sed tempus finibus, elit nunc tincidunt enim, vitae malesuada arcu sem et tortor. Maecenas molestie fringilla sapien vel dictum. Praesent vel iaculis lacus, et condimentum nunc. Donec rhoncus placerat erat in hendrerit. Suspendisse semper viverra lacus a luctus. Cras pharetra magna quis',
      isMe: true,
    ),
    Message(
      id: '5',
      message: 'What about you?',
      isMe: false,
    ),
    Message(
      id: '6',
      message: 'I am also fine',
      isMe: true,
    ),
    Message(
      id: '7',
      message: 'Good to hear that',
      isMe: false,
    ),
    Message(
      id: '8',
      message: 'Yes',
      isMe: true,
    ),
    Message(
      id: '9',
      message: 'Bye',
      isMe: false,
    ),
    Message(
      id: '10',
      message: 'Goodbye',
      isMe: true,
    ),
  ];
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          minWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        child: Stack(
          children: [
            // message
            buildMessage(
              context,
            ),
          ],
        ),
      ),
    );
  }

  // message widget
  Widget buildMessage(
    BuildContext context,
  ) {
    // padding for the message card
    final padding = message.isMe
        ? const EdgeInsets.only(left: 30.0, bottom: 25.0)
        : const EdgeInsets.only(right: 30.0, bottom: 25.0);
    // border radius for the message card
    final borderRadius = message.isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          );
    // car color
    final cardColor = message.isMe
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    // text color
    final textColor = message.isMe
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSecondary;
    return Padding(
      padding: padding,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReactionScreen extends StatefulWidget {
  const ReactionScreen({super.key});

  @override
  State<ReactionScreen> createState() => _ReactionScreenState();
}

class _ReactionScreenState extends State<ReactionScreen> {
  final List<String> reactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '😠',
    '➕',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: Message.messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = Message.messages[index];
                    return GestureDetector(
                      onLongPress: () {
                        Navigator.of(context).push(
                          HeroDialogRoute(
                            builder: (context) {
                              return SafeArea(
                                child: ReactionsDialogWidget(
                                  id: message.id,
                                  // unique id for message
                                  messageWidget: MessageWidget(message: message),
                                  reactionWidget: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade500,
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            offset: const Offset(0,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (var reaction in reactions)
                                            InkWell(
                                              onTap: () {
                                                debugPrint(
                                                  'Reaction tapped: $reaction',
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  4.0,
                                                  2.0,
                                                  4.0,
                                                  2,
                                                ),
                                                child: Text(
                                                  reaction,
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                
                                  widgetAlignment: message.isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Hero(
                        tag: message.id,
                        child: MessageWidget(message: message),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
