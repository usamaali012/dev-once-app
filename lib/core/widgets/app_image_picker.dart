import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, this.url, this.size = 52});
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  url ?? 'https://backend.tfsworks.com/files/common/placeholder.png'))),
    );
  }
}

class LocalImageWidget extends StatelessWidget {
  const LocalImageWidget({super.key, required this.url, this.size = 52});
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image:
              DecorationImage(fit: BoxFit.cover, image: FileImage(File(url)))),
    );
  }
}