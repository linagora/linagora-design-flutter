import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/avatar/round_avatar.dart';

Future<File?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    return File(result.files.single.path!);
  } else {
    // User canceled the picker
    return null;
  }
}

class CircleAvatarExample extends StatelessWidget {
  const CircleAvatarExample({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const RoundAvatar(
              imageProvider: AssetImage('assets/images/circle_avatar_ios.png'),
              text: 'KN', 
              size: 56, 
              linearGradientColors: const [Color(0xFF77EBF3), Color(0xFF008AA1)]),
              RoundAvatar(
                imageProvider: AssetImage('assets/images/circle_avatar_ios.png'),
                errorBuilder: (context) => Icon(Icons.favorite),
                text: 'Đ', 
                size: 56, 
                linearGradientColors: const [Color(0xFFBDF4A1), Color(0xFF52CE64)]),
              RoundAvatar(
                imageProvider: NetworkImage('https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg'),
                imageLoadingBuilder: (context, _, __) => Center(child: CircularProgressIndicator(color: Colors.amber)),
                text: 'Đ', 
                size: 56, 
                linearGradientColors: const [Color(0xFFBDF4A1), Color(0xFF52CE64)]),
              RoundAvatar(
                text: 'WW', 
                size: 56, 
                linearGradientColors: [Color(0xFFE4ABF0), Color(0xFFD96EED)]),
              RoundAvatar(
                text: 'Đ', 
                size: 56,),
              RoundAvatar(
                text: 'QKASDAS', 
                size: 56, 
                linearGradientColors: [Color(0xFFF19E86), Color(0xFFF95967)]),
              RoundAvatar(
                imageProvider: const NetworkImage('https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg'),
                text: 'Đ', 
                size: 56, 
                linearGradientColors: const [Color(0xFFF19E86), Color(0xFFF95967)]),
              RoundAvatar(
                imageProvider: const NetworkImage('https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg'),
                text: 'Đ', 
                size: 15, 
                linearGradientColors: const [Color(0xFFF19E86), Color(0xFFF95967)]),
              RoundAvatar(
                imageProvider: const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBJDXDX5Ni124-a1hw0pDfpnD1Scp8Ycv3uQ&usqp=CAU'),
                text: 'Đ', 
                size: 56),
              RoundAvatar(
                imageProvider: const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBJDXDX5Ni124-a1hw0pDfpnD1Scp8Ycv3uQ&usqp=CAU'),
                text: 'Đ', 
                size: 156),
              RoundAvatar(
                text: 'WW', 
                size: 40),
              RoundAvatar(
                text: 'DY', 
                size: 15),
              RoundAvatar(
                text: 'DY', 
                size: 100,
                textStyle: TextStyle(
                  fontSize: 50,
                )),
              RoundAvatar(
                imageProvider: const NetworkImage('https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg'),
                text: 'Đ', 
                size: 150)
          ],
        ),
      ),
    );
  }
  
}