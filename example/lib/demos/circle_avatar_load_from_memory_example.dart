import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linagora_design_flutter/avatar/round_avatar.dart';

Future<Uint8List> pngToUint8List(String imagePath) async {
  final bytes = await rootBundle.load(imagePath);
  final Uint8List pngBytes = bytes.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(pngBytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ui.Image data = frameInfo.image;
  final ByteData? byteData = await data.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}

class CircleAvatarLoadFromMemoryExample extends StatefulWidget {
  @override
  _CircleAvatarLoadFromMemoryExampleState createState() => _CircleAvatarLoadFromMemoryExampleState();
}

class _CircleAvatarLoadFromMemoryExampleState extends State<CircleAvatarLoadFromMemoryExample> {
  Uint8List? imageData;

  Future<void> _getImageFromBytes() async {
    imageData = await pngToUint8List('assets/images/circle_avatar_ios.png');
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Load image from memory'),
      ),
      body: RoundAvatar(
        text: 'NO',
        imageProvider: imageData != null ? MemoryImage(imageData!) : null,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImageFromBytes,
        tooltip: 'Load Image from memory',
        child: Icon(Icons.photo),
      ),
    );
  }
}
