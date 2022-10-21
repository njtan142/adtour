import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'destination_info_widget.dart';

class SpecialInterestNewsfeedWidget extends StatefulWidget {
  const SpecialInterestNewsfeedWidget({Key? key}) : super(key: key);

  @override
  State<SpecialInterestNewsfeedWidget> createState() =>
      _SpecialInterestNewsfeedWidgetState();
}

class _SpecialInterestNewsfeedWidgetState
    extends State<SpecialInterestNewsfeedWidget> {
  final Stream<QuerySnapshot> _destinationsStream = FirebaseFirestore.instance
      .collection('LocationsData')
      .doc('specialinterest')
      .collection('destinations')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _destinationsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cultural Tourist Attractions')),
            body: ListView(
              padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DestinationInfoWidget(data: data)));
                    },
                    title: Text(data['name']),
                    subtitle: Text(
                      data['description'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
