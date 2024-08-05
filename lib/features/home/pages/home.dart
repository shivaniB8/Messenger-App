import 'dart:developer';

import 'package:chatapp_two/common/res/app_bottomsheets.dart';
import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/widgets/bharat_ids_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:chatapp_two/common/util/constants.dart';
import 'package:chatapp_two/common/util/file_picker.dart';
import 'package:chatapp_two/features/call/widgets/call_list.dart';
import 'package:chatapp_two/features/home/widgets/chat_list.dart';
import 'package:chatapp_two/features/status/widgets/status_list.dart';
import 'package:chatapp_two/router.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late final TabController controller;
  static final kAppBarActionIconColor = Colors.grey.shade100;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    // update the state of the tab controller when the tab changes
    controller.addListener(() {
      if (controller.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    return PopScope(
      canPop: false,
      child: DefaultTabController(
        length: controller.length,
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kAppName.split(" ").first,
                    style: TextStyle(
                        height: 1,
                        fontSize: (MediaQuery.of(context).size.height +
                                MediaQuery.of(context).size.width) /
                            60)),
                Text(kAppName.split(" ").last,
                    style: TextStyle(
                        height: 1,
                        fontSize: (MediaQuery.of(context).size.height +
                                MediaQuery.of(context).size.width) /
                            105)),
              ],
            ),
            bottom: TabBar(
              controller: controller,
              indicatorColor: Colors.white,
              // themeMode == Brightness.light ? Colors.white : kPrimaryColor,
              labelColor: Colors.white,
              // themeMode == Brightness.light ? Colors.white : kPrimaryColor,
              unselectedLabelColor: kUnselectedLabelColor,
              indicatorWeight: 4,
              tabs: const [
                Tab(text: "Chat"),
                Tab(text: "Status"),
                Tab(text: "Calls"),
              ],
            ),
            actions: [
              // theme switcher
              // IconButton(
              //   splashRadius: kDefaultSplashRadius,
              //   onPressed: () {
              //     ref.read(themeNotifierProvider.notifier).toggle();
              //   },
              //   icon: themeMode == Brightness.light
              //       ? Icon(
              //           Icons.nightlight_outlined,
              //           color: kAppBarActionIconColor,
              //         )
              //       : Icon(
              //           Icons.wb_sunny_outlined,
              //           color: kAppBarActionIconColor,
              //         ),
              // ),

              IconButton(
                  onPressed: () async {
                    await scanner.scan().then((value) {
                      log("scanner opponent data > $value");

                      /// now select bharat id ...
                      AppBottomSheet.show(
                          context: context,
                          child:
                              BharatIdsListWidget(callback: (String bharatid) {
                            /// got the selected user's bharat id...
                            Navigator.pushNamed(context, PageRouter.chat);
                          }),
                          isDismissible: false,
                          backgroundColor: kLightBgColor);
                    });
                    // log("cameraScanResult > $cameraScanResult");

                    // Navigator.of(context).pushNamed(PageRouter.qrViewScreen);

                    // log("cameraScanResult > $cameraScanResult");
                    // Map<String, dynamic> mapScanResult =
                    //     jsonDecode(cameraScanResult ?? "");
                    // log("cameraScanResult > $cameraScanResult");
                    // Navigator.pushNamed(context, PageRouter.qrDetailsScreen,
                    //     arguments: {
                    //       "name": mapScanResult["name"],
                    //       "resident": mapScanResult["resident"],
                    //       "gender": mapScanResult["gender"],
                    //       "documents": mapScanResult["documents"],
                    //     });
                  },
                  icon: const Icon(CupertinoIcons.qrcode_viewfinder)),

              IconButton(
                splashRadius: kDefaultSplashRadius,
                onPressed: () {
                  Navigator.pushNamed(context, PageRouter.idsListScreen);
                },
                icon: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.white54,
                            strokeAlign: BorderSide.strokeAlignOutside)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("ID",
                            style: AppStyles.titleTextStyle(context)
                                .copyWith(color: kAppBarActionIconColor)),
                        Text("s",
                            style: AppStyles.titleTextStyle(context).copyWith(
                                fontSize:
                                    appSize(context: context, unit: 10) / 20,
                                color: kAppBarActionIconColor)),
                      ],
                    )),
              ),
              IconButton(
                splashRadius: kDefaultSplashRadius,
                onPressed: () {},
                color: kAppBarActionIconColor,
                icon: Icon(
                  Icons.search,
                  color: kAppBarActionIconColor,
                ),
              ),
              PopupMenuButton(
                splashRadius: kDefaultSplashRadius,
                icon: Icon(
                  Icons.more_vert,
                  color: kAppBarActionIconColor,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text(
                        "New Group",
                      ),
                      onTap: () {
                        // wait for the menu to close before navigating
                        Future(() => Navigator.pushNamed(
                            context, PageRouter.createGroup));
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Profile"),
                      onTap: () {
                        // wait for the menu to close before navigating
                        Future(() => Navigator.pushNamed(
                            context, PageRouter.userProfile));
                      },
                    ),
                  ];
                },
              ),
            ],
          ),
          body: TabBarView(
            controller: controller,
            children:const [
               ChatList(),
               StatusList(),
               CallList(),
            ],
          ),
          floatingActionButton: floatingWidgets,
        ),
      ),
    );
  }

  Widget get floatingWidgets {
    final lowerButton = FloatingActionButton(
      backgroundColor: kPrimaryColor,
      heroTag: 'lower',
      onPressed: () {
        if (controller.index == 1) {
          void pickStatusImage() async {
            final image =
                await FilePicker.pickFile(FilePickerSource.galleryImage);
            image.match(
              () => {},
              (file) {
                Navigator.pushNamed(context, PageRouter.statusImageConfirm,
                    arguments: file);
              },
            );
          }

          pickStatusImage();
        } else {
          Navigator.pushNamed(context, PageRouter.selectContact);
        }
      },
      child: Icon(controller.index == 1 ? Icons.photo_camera : Icons.comment,
          color: Colors.white),
    );
    return Column(
      children: [
        const Spacer(),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 50),
          opacity: controller.index == 1 ? 1 : 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 185),
            width: 45,
            height: 45,
            child: FloatingActionButton(
              heroTag: 'writer',
              onPressed: () {
                Navigator.pushNamed(context, PageRouter.statusWriter);
              },
              backgroundColor: kDarkTextFieldBgColor,
              mini: true,
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        lowerButton,
      ],
    );
  }
}
