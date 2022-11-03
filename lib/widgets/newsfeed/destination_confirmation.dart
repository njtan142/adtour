import 'dart:async';

import 'package:android_app/widgets/newsfeed/classifier.dart';
import 'package:android_app/widgets/newsfeed/try.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import '../map/map_widget.dart';
import '../map/mapbox_widget.dart';

class DestinationConfirmationWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  final CollectionReference collectionReference;
  const DestinationConfirmationWidget(
      {Key? key,
      required this.data,
      required this.id,
      required this.collectionReference})
      : super(key: key);

  @override
  State<DestinationConfirmationWidget> createState() =>
      _DestinationConfirmationWidgetState();
}

class _DestinationConfirmationWidgetState
    extends State<DestinationConfirmationWidget> {
  Classifier _classifier = Classifier();
  late Stream<QuerySnapshot> _destinationsStream;
  Widget comments = Center(
    child: CircularProgressIndicator(),
  );
  Timer? timer;
  bool confirmed = false;
  bool loaded = false;
  final commentController = TextEditingController();

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(name: "Destination Views");
    _destinationsStream = widget.collectionReference.snapshots();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkIfLoaded());
    // TODO: implement initState
    print(widget.data);
    print(widget.id);
    print(widget.collectionReference.path);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    commentController.dispose();
    super.dispose();
  }

  void checkIfLoaded() {
    if (_classifier.loaded == 2) {
      setState(() {
        comments = getComments(context);
      });
      _classifier.loaded = 0;
    }
  }

  void confirmLocation(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 100),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 200,
            width: 300,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Confirm Check In",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Your location is near {<Desination>}, do you want to check in?",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              confirmed = true;
                            });
                            Navigator.of(context).pop();
                          },
                          child: new Text('Yes please'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyHomePage(title: 'Adtour')));
                          },
                          child: new Text('No, go back'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  void commentUploaded(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 100),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 200,
            width: 300,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Comment Uploaded!",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Comment has been submitted successfully",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MyHomePage(title: 'Adtour')));
                          },
                          child: new Text('Okay'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Widget getComments(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _destinationsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              final prediction = _classifier.classify(data['comment']);

              return Card(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: prediction[1] > prediction[0]
                      ? Colors.lightGreen
                      : Colors.redAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data['comment'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.expand(
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.data["name"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  widget.data["image_url"] == null
                      ? SizedBox(
                          width: 300,
                          height: 50,
                        )
                      : Image.network(
                          widget.data["image_url"],
                          height: 350,
                          fit: BoxFit.cover,
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.data["description"],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Reviews",
                    style: TextStyle(fontSize: 30),
                  ),
                  Flexible(
                    child: comments,
                  )
                ],
              ),
            )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //children here
                  ...(!confirmed
                      ? <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                confirmLocation(context);
                              },
                              child: Text("Write a review"))
                        ]
                      : <Widget>[
                          Expanded(
                              child: TextField(
                            controller: commentController,
                          )),
                          ElevatedButton(
                              onPressed: () {
                                FirebaseAnalytics.instance
                                    .logEvent(name: "Feedback");
                                DateTime today = DateTime.now();
                                logFeedback();

                                FirebaseFirestore.instance
                                    .collection('admin')
                                    .doc('analytics')
                                    .get()
                                    .then((analyticsReference) {
                                  Map<String, dynamic> data = {};
                                  if (analyticsReference.data() != null) {
                                    data = analyticsReference.data()
                                        as Map<String, dynamic>;
                                  }
                                  if (data['check_ins'] != null) {
                                    data['check_ins'] += 1;
                                  } else {
                                    data['check_ins'] = 1;
                                  }
                                  FirebaseFirestore.instance
                                      .collection('admin')
                                      .doc('analytics')
                                      .set(data, SetOptions(merge: true))
                                      .then((value) {
                                    FirebaseFirestore.instance
                                        .collection('admin')
                                        .doc('analytics')
                                        .collection('check_ins')
                                        .doc(
                                            "${today.year}-${today.month}-${today.day}")
                                        .get()
                                        .then((analyticsReference) {
                                      Map<String, dynamic> data = {};
                                      if (analyticsReference.data() != null) {
                                        data = analyticsReference.data()
                                            as Map<String, dynamic>;
                                      }
                                      if (data['check_ins'] != null) {
                                        data['check_ins'] += 1;
                                      } else {
                                        data['check_ins'] = 1;
                                      }
                                      FirebaseFirestore.instance
                                          .collection('admin')
                                          .doc('analytics')
                                          .collection('check_ins')
                                          .doc("${today.year}-${today.month}")
                                          .set(data, SetOptions(merge: true))
                                          .then((value) {
                                        widget.collectionReference.add({
                                          'comment': commentController.text,
                                          'user_id': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'uploaded': Timestamp.now()
                                        }).then((value) {
                                          String id = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(id)
                                              .collection("check_ins")
                                              .doc()
                                              .set({
                                            'path': value.path,
                                          }, SetOptions(merge: true)).then(
                                                  ((value) {
                                            commentUploaded(context);
                                          }));
                                        });
                                      });
                                    });
                                  });
                                });
                              },
                              child: Text("Submit"))
                        ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logFeedback() {
    final prediction = _classifier.classify(commentController.text);

    String result = prediction[1] > prediction[0] ? 'positive' : 'negative';

    FirebaseFirestore.instance
        .collection('admin')
        .doc('analytics')
        .get()
        .then((analyticsReference) {
      Map<String, dynamic> data = {};
      if (analyticsReference.data() != null) {
        data = analyticsReference.data() as Map<String, dynamic>;
      }
      if (data[result] != null) {
        data[result] += 1;
      } else {
        data[result] = 1;
      }

      FirebaseFirestore.instance
          .collection('admin')
          .doc('analytics')
          .set(data, SetOptions(merge: true));
    });

    FirebaseFirestore.instance
        .collection('admin')
        .doc('analytics')
        .get()
        .then((analyticsReference) {
      Map<String, dynamic> data = {};
      if (analyticsReference.data() != null) {
        data = analyticsReference.data() as Map<String, dynamic>;
      }
      if (data['feedbacks'] != null) {
        data['feedbacks'] += 1;
      } else {
        data['feedbacks'] = 1;
      }

      FirebaseFirestore.instance
          .collection('admin')
          .doc('analytics')
          .set(data, SetOptions(merge: true));
    });
  }
}
