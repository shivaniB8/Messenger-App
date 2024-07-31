import 'package:flutter/material.dart';

class QrDetailsScreen extends StatelessWidget {
  const QrDetailsScreen(
      {super.key,
      required this.name,
      required this.resident,
      required this.gender,
      required this.documents});

  final String name;
  final String resident;
  final String gender;
  final List<String> documents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Name: $name"),
            Text("Resident: $resident"),
            Text("Gender: $gender"),
            Text("Documents Check: "),
            Column(children: [])
          ],
        ),
      ),
    );
  }
}
