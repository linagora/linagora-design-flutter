import 'package:example/demos/circle_avatar_example.dart';
import 'package:example/demos/circle_avatar_load_from_memory_example.dart';
import 'package:example/demos/image_picker_bottom_sheet_example.dart';
import 'package:example/demos/image_picker_example.dart';
import 'package:flutter/material.dart';


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
          DemoTile(component: CircleAvatarExample(), title: 'Demo CircleAvatar component',),
          DemoTile(title: 'Demo CircleAvatar component with load image from bytes', component: CircleAvatarLoadFromMemoryExample()),
          DemoTile(title: 'Demo Image picker', component: ImagesPickerExample()),
          DemoTile(title: "Demo Image picker with bottom sheet", component: ImagePickerBottomSheetExample()),
        ],
      ),
    );
  }

}

class DemoTile extends StatelessWidget {
  final String title;

  final Widget component;

  const DemoTile({
    super.key, 
    required this.title, 
    required this.component
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => component),
        );
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(100, 50))
      ),
      child: Text('$title'),
    );
  }
}
