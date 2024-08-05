import 'package:flutter/material.dart';

class QrDetailsWidget extends StatelessWidget {
  const QrDetailsWidget({super.key, this.data});

  final String? data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Bharat ID: ${data?.split("/")}"),
        ],
      ),
    );
  }
}
