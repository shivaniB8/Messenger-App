import 'package:chatapp_two/common/theme.dart';
import 'package:flutter/material.dart';

class AppBottomSheet {
  static show(
          {required BuildContext context,
          required Widget child,
          required bool isDismissible,
          Function(dynamic v)? then,
          required Color backgroundColor}) =>
      showModalBottomSheet(
          isDismissible: isDismissible,
          context: context,
          isScrollControlled: true,
          backgroundColor: backgroundColor,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(33), topRight: Radius.circular(33)),
          ),
          builder: (context) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Material(color: Colors.transparent, child: child));
          }).then((v) => then!(v));
}
