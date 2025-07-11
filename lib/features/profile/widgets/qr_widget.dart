import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrWidget extends StatelessWidget {
  const QrWidget(
      {super.key,
      required this.qrData,
      this.bharatIdLabel = "",
      required this.qrVersion});

  final String qrData;
  final String bharatIdLabel;
  final int qrVersion;

  @override
  Widget build(BuildContext context) {
    double size = appSize(context: context, unit: 10) / 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.circle,
                  color: kPrimaryColor.withOpacity(.6)),
              data: qrData,
              version: qrVersion,
              // 1 to 40
              size: size + 300,
              gapless: false,
              // embeddedImage: Image.asset("assets/img/bmlogo.png").image,
              // embeddedImageStyle: const QrEmbeddedImageStyle(
              //   size: Size(80, 80),
              // ),
            ),
            const SizedBox(height: 12),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        color: Colors.grey.withOpacity(.6),
                        offset: const Offset(0, 2),
                        blurRadius: 2,
                      )
                    ],
                    color: kPrimaryColor.withOpacity(.6),
                    borderRadius: BorderRadius.circular(22)),
                child: Text("ID: $bharatIdLabel",
                    style: AppStyles.titleTextStyle(context)
                        .copyWith(color: kLightBgColor))),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(CupertinoIcons.check_mark_circled_solid,
                    color: Colors.green),
                const SizedBox(width: 6),
                Text("User Verified",
                    style: AppStyles.titleTextStyle(context).copyWith()),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ],
    );
  }
}
