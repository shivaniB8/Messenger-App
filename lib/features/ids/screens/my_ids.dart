import 'dart:developer';
import 'package:chatapp_two/common/res/app_styles.dart';
import 'package:chatapp_two/common/util/misc.dart';
import 'package:chatapp_two/features/ids/widgets/my_ids_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyIdsScreen extends ConsumerStatefulWidget {
  const MyIdsScreen({super.key});

  @override
  ConsumerState<MyIdsScreen> createState() => _MyIdsScreenState();
}

class _MyIdsScreenState extends ConsumerState<MyIdsScreen> {
  bool _primaryIdValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.9),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("+ Add ID"),
        onPressed: () {
          createCollectionUnderDocument();
        },
      ),
      appBar: const MyIdsAppBar(),
      body: Column(
        children: [
          Material(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Primary ID",
                      style: AppStyles.subTitleTextStyle(context)),
                  const SizedBox(height: 12),
                  _idContainer("abhijeet@bm", _primaryIdValue, (v) {
                    setState(() {
                      _primaryIdValue = v;
                    });
                  })
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Material(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Secondary IDs",
                      style: AppStyles.subTitleTextStyle(context)),
                  const SizedBox(height: 12),
                  _idContainer("abhijeet@taxpay", _primaryIdValue, (v) {})
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _idContainer(id, bool idValue, onChanged) => SwitchListTile(
        // tileColor: Colors.red,
        title: Text(id),
        value: true,
        onChanged: onChanged,
      );

  void createCollectionUnderDocument() async {
    // Reference to the document under which the new collection will be created
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("users").doc(getUserId(ref));
    log("docRef : $docRef");

    // Reference to the new collection under the document
    CollectionReference newCollection = docRef.collection("bharat_ids");
    log("newCollection : $newCollection");

    // Adding a new document to the new collection
    var ne = await newCollection.add({
      'bharat_id': 'abhijeet@bharatm',
      'type': 1
      // 'timestamp': FieldValue.serverTimestamp(),
    });
    log("newCollection add: $ne");
    print('New collection and document created');
  }
}
