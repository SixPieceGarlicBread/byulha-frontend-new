//image_recognition_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taba/modules/orb/components/components.dart';

import '../../../domain/perfume/perfume_list_provider.dart';

class ImageRecognitionScreen extends ConsumerStatefulWidget {
  const ImageRecognitionScreen({Key? key}) : super(key: key);

  @override
  createState() => _ImageRecognitionScreenState();
}

class _ImageRecognitionScreenState
    extends ConsumerState<ImageRecognitionScreen> {
  final PageController _pageController = PageController();
  final int _totalSlides = 3; // 총 튜토리얼 페이지 수
  final ImagePicker _picker = ImagePicker();

  XFile? image;

  Future<void> _pickImage() async {
    // 이미지 픽커로 이미지를 가져옵니다.
    Permission.photos.request().isGranted.then((value) async {
      if (value) {
        final pickedImage =
            await _picker.pickImage(source: ImageSource.gallery);
        setState(() {
          if (pickedImage != null) {
            image = pickedImage;
          }
        });
      } else {
        [Permission.photos].request();
      }
    });
    // 선택된 이미지를 다루는 로직을 여기에 추가하세요.
  }

  @override
  Widget build(BuildContext context) {
    return OrbScaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            image != null
                ? Image.file(
                    File(image!.path),
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    'assets/images/main_image1.png',
                    height: 300,
                    fit: BoxFit.fill,
                  ),
            const SizedBox(height: 24),
            OrbButton(
              buttonText: '이미지 선택',
              onPressed: () async {
                await _pickImage();
              },
            ),
          ],
        ),
      ),
      submitButton: OrbButton(
        buttonText: '향수 추천 시작',
        onPressed: () async {
          final List<XFile> images = [image!];
          ref
              .read(recommendedPerfumeListProvider.notifier)
              .getPerfumeList(images);
        },
      ),
    );
  }
}
