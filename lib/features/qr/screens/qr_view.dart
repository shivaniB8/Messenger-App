// import 'dart:developer';
// import 'dart:io';
//
// import 'package:chatapp_two/common/repositories/user.dart';
// import 'package:chatapp_two/common/res/app_bottomsheets.dart';
// import 'package:chatapp_two/common/res/app_functions.dart';
// import 'package:chatapp_two/common/res/app_styles.dart';
// import 'package:chatapp_two/common/theme.dart';
// import 'package:chatapp_two/common/util/constants.dart';
// import 'package:chatapp_two/common/util/misc.dart';
// import 'package:chatapp_two/common/widgets/bharat_ids_list_widget.dart';
// import 'package:chatapp_two/features/contact/controllers/contact.dart';
// import 'package:chatapp_two/router.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class QRViewExample extends ConsumerStatefulWidget {
//   const QRViewExample({super.key});
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _QRViewExampleState();
// }
//
// class _QRViewExampleState extends ConsumerState<QRViewExample> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   String? selectedBharatId;
//
//   @override
//   void initState() {
//     super.initState();
//     _buildBharatIDS();
//   }
//
//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//           Expanded(
//             flex: 1,
//             child: FittedBox(
//               fit: BoxFit.contain,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   const SizedBox(height: 12),
//                   if (result != null)
//                     Text(
//                         'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
//                   else
//                     Text(
//                       'Scan a code',
//                       style: AppStyles.subTitleTextStyle(context),
//                     ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       FutureBuilder(
//                           future: controller?.getFlashStatus(),
//                           builder: (context, snapshot) {
//                             return IconButton(
//                                 onPressed: () async {
//                                   await controller?.toggleFlash();
//                                   setState(() {});
//                                 },
//                                 icon: Icon((snapshot.data ?? false)
//                                     ? Icons.flashlight_on_rounded
//                                     : Icons.flashlight_off_rounded));
//                           }),
//                       Container(
//                           margin: const EdgeInsets.all(8),
//                           child: FutureBuilder(
//                               future: controller?.getCameraInfo(),
//                               builder: (context, snapshot) {
//                                 return IconButton(
//                                     onPressed: () async {
//                                       await controller?.flipCamera();
//                                       setState(() {});
//                                     },
//                                     icon: Icon((snapshot.data != null)
//                                         ? CupertinoIcons.switch_camera_solid
//                                         : CupertinoIcons.switch_camera));
//                               })),
//                       // Container(
//                       //   margin: const EdgeInsets.all(8),
//                       //   child: ElevatedButton(
//                       //       onPressed: () async {
//                       //         await controller?.flipCamera();
//                       //         setState(() {});
//                       //       },
//                       //       child: FutureBuilder(
//                       //         future: controller?.getCameraInfo(),
//                       //         builder: (context, snapshot) {
//                       //           if (snapshot.data != null) {
//                       //             return Text(
//                       //                 'Camera facing ${describeEnum(snapshot.data!)}');
//                       //           } else {
//                       //             return const Text('loading');
//                       //           }
//                       //         },
//                       //       )),
//                       // )
//                     ],
//                   ),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   crossAxisAlignment: CrossAxisAlignment.center,
//                   //   children: <Widget>[
//                   //     Container(
//                   //       margin: const EdgeInsets.all(8),
//                   //       child: ElevatedButton(
//                   //         onPressed: () async {
//                   //           await controller?.pauseCamera();
//                   //         },
//                   //         child: const Text('pause',
//                   //             style: TextStyle(fontSize: 20)),
//                   //       ),
//                   //     ),
//                   //     Container(
//                   //       margin: const EdgeInsets.all(8),
//                   //       child: ElevatedButton(
//                   //         onPressed: () async {
//                   //           await controller?.resumeCamera();
//                   //         },
//                   //         child: const Text('resume',
//                   //             style: TextStyle(fontSize: 20)),
//                   //       ),
//                   //     )
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   void _buildBharatIDS() async {
//     await Future.delayed(const Duration(milliseconds: 900));
//     AppBottomSheet.show(
//         context: context,
//         child: BharatIdsListWidget(callback: (String id) async {
//           // setState(() {
//           //   selectedBharatId = id;
//           // });
//           Navigator.of(context).pop([id]);
//         }),
//         isDismissible: true,
//         backgroundColor: kLightBgColor,
//         then: (v) {
//           if (v != null) {
//             log("selected > ${v[0]}");
//             setState(() {
//               selectedBharatId = v[0];
//             });
//           } else {
//             Navigator.pop(context);
//           }
//         });
//   }
//
//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return Stack(
//       children: [
//         QRView(
//           key: qrKey,
//           onQRViewCreated: _onQRViewCreated,
//           overlay: QrScannerOverlayShape(
//               borderColor: Colors.red,
//               borderRadius: 10,
//               borderLength: 30,
//               borderWidth: 10,
//               cutOutSize: scanArea),
//           onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//         ),
//         SafeArea(
//           child: Align(
//             alignment: Alignment.topRight,
//             child: IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 icon: const Icon(Icons.clear_rounded),
//                 color: Colors.white),
//           ),
//         ),
//         if (selectedBharatId != null)
//           Positioned(
//             right: 0,
//             left: 0,
//             top: appSize(context: context, unit: 10) - 80,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     _buildBharatIDS();
//                   },
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                     decoration: BoxDecoration(
//                       color: kPrimaryColor.withOpacity(.8),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         Stack(
//                           alignment: Alignment.bottomRight,
//                           children: [
//                             Icon(
//                               CupertinoIcons.person_crop_circle_fill,
//                               color: Colors.grey,
//                               size: appSize(context: context, unit: 10) / 8,
//                             ),
//                             CircleAvatar(
//                                 backgroundColor: kDarkBgColor,
//                                 radius: 7,
//                                 child: Center(
//                                   child: Text("ID",
//                                       style:
//                                           AppStyles.subTitleTextStyle(context)
//                                               .copyWith(
//                                                   color: Colors.white,
//                                                   fontSize: appSize(
//                                                           context: context,
//                                                           unit: 10) /
//                                                       30)),
//                                 ))
//                           ],
//                         ),
//                         const SizedBox(width: 6),
//                         Text(selectedBharatId ?? ""),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//       ],
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//         log("scan data :: $result");
//       });
//       // get scanned user details from firebase ...
//       // ref.read(userRepositoryProvider).users.doc();
//       // goToContact(ref, con, context, false);
//     });
//   }
//
//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('no Permission')),
//       );
//     }
//   }
//
//   void goToContact(
//       WidgetRef ref, Contact con, BuildContext context, bool isDark) {
//     ref.read(selectContactProvider).findContact(
//           selected: con,
//           contactNotFound: () {
//             /// contact not registered
//             /// select any one of bharat ids
//             /// take to the chat room to send message
//             /// show alert saying : the user is not registered on Bharat Messenger, once he registers then he will see your message
//             /// as sender send first message , the receiver gets regsitered in database
//             ///
//             // AppBottomSheet.show(
//             //     context: context,
//             //     child: BharatIdsListWidget(
//             //       callback: (bharatId) async {
//             //         /// register the user first and get the uid.
//             //         await ref.read(userRepositoryProvider).create(
//             //               name: con.displayName,
//             //               avatar: const Option<File>.none(),
//             //               onError: (error) => showSnackbar(context, error),
//             //               onSuccess: () => {
//             //                 Navigator.pushNamedAndRemoveUntil(
//             //                     context, PageRouter.home, (route) => false),
//             //               },
//             //             );
//             //
//             //         // Navigator.pushReplacementNamed(context, PageRouter.chat,
//             //         //     arguments: {
//             //         //       "bharatId": bharatId,
//             //         //       "phoneNumber": con.phones.first.normalizedNumber,
//             //         //       'isGroup': false,
//             //         //       'streamId': con.uid,
//             //         //       'name': user.name,
//             //         //       'avatarImage': user.profileImage,
//             //         //     });
//             //       },
//             //     ),
//             //     isDismissible: true,
//             //     backgroundColor: isDark ? kDarkBgColor : kLightBgColor);
//             log("contact not registered :: ${con}");
//             showSnackbar(
//               context,
//               "This contact is not registered on $kAppName",
//             );
//           },
//           contactFound: (user) {
//             ///  contact found successfully..
//             ///  show all bharat ids list to choose one or create new
//             ///  start chat window
//             ///  start sending messages
//             ///
//
//             AppBottomSheet.show(
//                 context: context,
//                 child: BharatIdsListWidget(
//                   callback: (bharatId) {
//                     Navigator.pushReplacementNamed(context, PageRouter.chat,
//                         arguments: {
//                           "bharatId": bharatId,
//                           "phoneNumber": user.phoneNumber,
//                           'isGroup': false,
//                           'streamId': user.uid,
//                           'name': user.name,
//                           'avatarImage': user.profileImage,
//                         });
//                   },
//                 ),
//                 isDismissible: true,
//                 backgroundColor: isDark ? kDarkBgColor : kLightBgColor);
//
//             // Navigator.pushReplacementNamed(context, PageRouter.chat,
//             //     arguments: {
//             //       "bharatId": "",
//             //       "phoneNumber": user.phoneNumber,
//             //       'isGroup': false,
//             //       'streamId': user.uid,
//             //       'name': user.name,
//             //       'avatarImage': user.profileImage,
//             //     });
//           },
//         );
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
