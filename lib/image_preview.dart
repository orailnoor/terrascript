import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io'; // Import for File class
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Import for path_provider
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class ImagePreview extends StatefulWidget {
  final Uint8List? imageFile;

  const ImagePreview({super.key, required this.imageFile});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final anchor = AnchorElement(
            href: 'data:image/png;base64,${base64Encode(widget.imageFile!)}',
          )
            ..setAttribute('download', 'image.png')
            ..click();
        },
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: widget.imageFile != null
              ? Image.memory(widget.imageFile!)
              : const Text('No image available'), // Handle no image case
        ),
      ),
    );
  }
}
