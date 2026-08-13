import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double sidebarWidth = 204;

/// Ambient conditions used by [pumpSidebar].
class SidebarSurface {
  const SidebarSurface({
    this.width = sidebarWidth,
    this.brightness = Brightness.light,
    this.textDirection = TextDirection.ltr,
  });

  final double width;
  final Brightness brightness;
  final TextDirection textDirection;
}

Future<void> pumpSidebar(
  WidgetTester tester,
  Widget child, {
  SidebarSurface surface = const SidebarSurface(),
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Theme(
        // An inner theme switches synchronously between test pumps. MaterialApp
        // animates theme changes, which otherwise exposes the previous
        // brightness for the first assertion after changing [surface].
        data: ThemeData(brightness: surface.brightness),
        child: Scaffold(
          body: Directionality(
            textDirection: surface.textDirection,
            child: SizedBox(width: surface.width, child: child),
          ),
        ),
      ),
    ),
  );
}
