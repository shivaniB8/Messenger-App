import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrWidget extends StatelessWidget {
  const QrWidget({super.key, required this.qrData});

  final String qrData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
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
                version: QrVersions.min,
                size: 200.0,
                gapless: false,
                // embeddedImage:
                //     const AssetImage('assets/img/bmlogo.png'),
                // embeddedImageStyle: const QrEmbeddedImageStyle(
                //   size: Size(80, 80),
                // ),
              ),
              const SizedBox(height: 6),
              Text("ID: AA/PA/VO/DL/PP/RC",
                  style: AppStyles.titleTextStyle(context)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 6),
                  Text("User Verified",
                      style: AppStyles.titleTextStyle(context).copyWith()),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
