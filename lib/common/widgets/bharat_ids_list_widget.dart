import 'dart:developer';
import 'dart:ffi';

import 'package:chatapp_two/common/models/bharat_id.dart';
import 'package:chatapp_two/common/repositories/user.dart';
import 'package:chatapp_two/common/res/app_functions.dart';
import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/theme.dart';
import 'package:chatapp_two/common/util/misc.dart';
import 'package:chatapp_two/common/widgets/app_button.dart';
import 'package:chatapp_two/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BharatIdsListWidget extends ConsumerStatefulWidget {
  const BharatIdsListWidget({
    super.key,
    required this.callback,
  });

  final Function(String bharatid) callback;

  @override
  ConsumerState<BharatIdsListWidget> createState() =>
      _BharatIdsListWidgetState();
}

class _BharatIdsListWidgetState extends ConsumerState<BharatIdsListWidget> {
  List<BharatIdModel> secIds = [];
  BharatIdModel? priId;

  @override
  void initState() {
    super.initState();
    _getIds();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Select one bharat id to continue chat",
                  style: AppStyles.titleTextStyle(context).copyWith(
                      fontSize: appSize(context: context, unit: 10) / 15)),
            ],
          ),
          const SizedBox(height: 12),
          Text("Primary ID:", style: AppStyles.subTitleTextStyle(context)),
          _idContainer(priId?.bharatId ?? "", () {
            widget.callback.call(priId?.bharatId ?? "");
          }),
          const SizedBox(height: 12),
          if (secIds.isNotEmpty)
            Text("Secondary IDs:", style: AppStyles.subTitleTextStyle(context)),
          ...List.generate(
              secIds.length,
              (index) => _idContainer(secIds[index].bharatId, () {
                    widget.callback.call(secIds[index].bharatId);
                  })),
          AppButton(
            title: "Create New",
            onTap: () => Navigator.pushReplacementNamed(
                context, PageRouter.idsListScreen),
          ),
        ],
      ),
    );
  }

  _idContainer(String bharatid, Function() onTap) => Container(
        child: ListTile(
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Icon(
                CupertinoIcons.person_crop_circle_fill,
                color: Colors.grey,
                size: appSize(context: context, unit: 10) / 8,
              ),
              CircleAvatar(
                  backgroundColor: kDarkBgColor,
                  radius: 7,
                  child: Center(
                    child: Text("ID",
                        style: AppStyles.subTitleTextStyle(context).copyWith(
                            color: Colors.white,
                            fontSize:
                                appSize(context: context, unit: 10) / 30)),
                  ))
            ],
          ),
          title: Text(bharatid),
          onTap: onTap,
        ),
      );

  void _getIds() async {
    List<BharatIdModel> list = await ref
        .read(userRepositoryProvider)
        .bharatIds(getUserId(ref))
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
    log("list >> $list");

    setState(() {
      secIds = list.where((element) => element.type == 2).toList();
      log("secIds > $secIds");
      List<BharatIdModel> primaryIdList =
          list.where((element) => element.type == 1).toList();

      // var s = ref
      //     .read(userRepositoryProvider)
      //     .bharatIds(getUserId(ref))
      //     .doc(secIds[0].toString())
      //     .path;
      // log("bharat document id >> $s");

      if (primaryIdList.length == 1) {
        priId = primaryIdList.single;
        log("primary ID > $primaryIdList");
        log("primary ID > $priId");
      } else {
        //TODO : show alert as error for showing primary id more than one...
      }
    });
  }
}
