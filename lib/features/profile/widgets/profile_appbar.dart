import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/util/constants.dart';

class ProfileAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ProfileAppBar(
      this.roomAvatar, this.userName, this.mobileNo, this.bharatId,
      {super.key});

  final String roomAvatar;
  final String userName;
  final String mobileNo;
  final String bharatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double size =
        MediaQuery.of(context).size.height + MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {},
      child: Hero(
        tag: userName,
        child: AppBar(
          leading: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              splashRadius: kDefaultSplashRadius,
            ),
          ),
          toolbarHeight: kToolbarHeight + 300,
          // bottom: PreferredSize(
          //     preferredSize: preferredSize,
          //     child: ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: size / 17,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    backgroundImage: NetworkImage(roomAvatar),
                  ),
                  const SizedBox(height: 8),
                  Text(userName, style: TextStyle(fontSize: size / 50)),
                  Text(
                    mobileNo,
                    style:
                        TextStyle(fontSize: size / 80, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bharatId,
                    style:
                        TextStyle(fontSize: size / 80, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.phone,
                              color: kUnselectedLabelColor,
                              size: size / 45,
                            ),
                            Text(
                              "Audio",
                              style: TextStyle(
                                  fontSize: size / 80, color: Colors.white70),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30)),
                        child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.videocam,
                              color: kUnselectedLabelColor,
                              size: size / 45,
                            ),
                            Text(
                              "Video",
                              style: TextStyle(
                                  fontSize: size / 80, color: Colors.white70),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          actions: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                splashRadius: kDefaultSplashRadius,
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 250);
}
