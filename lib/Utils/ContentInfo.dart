// ignore_for_file: library_prefixes, file_names

import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:public_vptax/Resources/ImagePath.dart' as imagePath;
import 'package:public_vptax/Resources/ColorsValue.dart' as c;

enum ContentType {
  fail,
  success,
  warning,
  help,
}

class ContentInfo {
  final String assetPath;
  final String title;
  final Color color;

  ContentInfo(
      {required this.title, required this.assetPath, required this.color});
}

ContentInfo getContentInfo(ContentType contentType) {
  switch (contentType) {
    case ContentType.fail:
      return ContentInfo(
          title: 'fail'.tr().toString(),
          assetPath: imagePath.failure,
          color: c.failureRed);
    case ContentType.success:
      return ContentInfo(
          title: 'success'.tr().toString(),
          assetPath: imagePath.success,
          color: c.successGreen);
    case ContentType.warning:
      return ContentInfo(
          title: 'warning'.tr().toString(),
          assetPath: imagePath.warning,
          color: c.warningYellow);
    case ContentType.help:
      return ContentInfo(
          title: 'help'.tr().toString(),
          assetPath: imagePath.help,
          color: c.helpBlue);
    default:
      return ContentInfo(
          title: 'fail'.tr().toString(),
          assetPath: imagePath.failure,
          color: c.failureRed);
  }
}
