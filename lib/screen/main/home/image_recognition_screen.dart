//image_recognition_screen.dart
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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
  final int _totalSlides = 1; // 총 튜토리얼 페이지 수
  final ImagePicker _picker = ImagePicker();

  XFile? image;

  Future<void> _pickImage() async {
    // 이미지 픽커로 이미지를 가져옵니다.

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      if (deviceInfo.version.sdkInt > 32) {
        await Permission.photos.request().isGranted.then((value) async {
          if (value) {
            pickImage();
          } else {
            [Permission.photos].request();
          }
        });
        if (await Permission.photos.isDenied ||
            await Permission.photos.isPermanentlyDenied) {
          openAppSettings();
        }
      } else {
        await Permission.storage.request().isGranted.then((value) async {
          if (value) {
            pickImage();
          } else {
            [Permission.storage].request();
          }
        });
      }
      if (await Permission.storage.isDenied ||
          await Permission.storage.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      Permission.photos.request().isGranted.then((value) async {
        if (value) {
          pickImage();
        } else {
          [Permission.photos].request();
        }
      });
      if (await Permission.photos.isDenied ||
          await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
    }

    // 선택된 이미지를 다루는 로직을 여기에 추가하세요.
  }

  void pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        image = pickedImage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrbScaffold(
      orbAppBar: OrbAppBar(
        title: '<AI조향사 리비>에게 추천받기',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        showLoadingIndicator:
            ref.watch(recommendedPerfumeListProvider).isLoading,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            image != null
                ? Image.file(
                    File(image!.path),
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    'assets/images/tutorial.jpg',
                    height: 400,
                    fit: BoxFit.fill,
                  ),
            const SizedBox(height: 16),
            OrbButton(
              buttonText: '이미지 선택하기',
              onPressed: () async {
                await _pickImage();
              },
            ),
          ],
        ),
      ),
      submitButton: OrbButton(
        buttonText: '이미지로 시향 시작하기',
        onPressed: () async {
          final List<XFile> images = [image!];
          ref
              .read(recommendedPerfumeListProvider.notifier)
              .getPerfumeList(images);

          // 첫 번째 스낵바 띄우기
          // 첫 번째 OrbSnackBar 띄우기
          OrbSnackBar.show(
            context: context,
            message: '리비에게 10초만 시간을 주세요!',
            type: OrbSnackBarType.info,
          );
          Future.delayed(Duration(seconds: 2), () {
            OrbSnackBar.show(
              context: context,
              message: '리비가 이미지를 유심히 관찰하고 있습니다.',
              type: OrbSnackBarType.info,
            );
          });
          Future.delayed(Duration(seconds: 5), () {
            OrbSnackBar.show(
              context: context,
              message: '리비가 향수를 찾고 있습니다.',
              type: OrbSnackBarType.info,
            );
          });
          Future.delayed(Duration(seconds: 7), () {
            OrbSnackBar.show(
              context: context,
              message: '리비가 향수를 가져왔어요!',
              type: OrbSnackBarType.info,
            );
          });


        },
      ),
    );
  }
}
