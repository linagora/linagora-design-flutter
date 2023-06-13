
import 'dart:ui';

import 'package:flutter/material.dart';

class UseCameraWidget extends StatelessWidget {

  final ImageProvider<Object>? backgroundImage;

  final void Function()? onPressed;

  const UseCameraWidget({
    super.key,
    this.backgroundImage,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: backgroundImage != null 
                    ? DecorationImage(
                      image: backgroundImage!,
                    )
                    : null,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              Icon(
                Icons.photo_camera_rounded, 
                size: 40,
                color: Theme.of(context).colorScheme.surfaceVariant,
              )
            ],
          ),
        ),
      ),
    );
  }
}