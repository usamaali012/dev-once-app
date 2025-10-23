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
          // boxShadow: [BoxShadow(
          //     color: Colors.grey.withOpacity(0.8), // Shadow color with opacity
          //     spreadRadius: 0,                   // How much the shadow spreads
          //     blurRadius: 10,                     // How blurry the shadow is
          //     offset: const Offset(0, 3),        // Offset of the shadow (x, y)
          //   ),
          // ],
          image: DecorationImage(
              fit: BoxFit.fill ,
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