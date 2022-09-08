import 'package:android_app/widgets/newsfeed/cultural.dart';
import 'package:android_app/widgets/newsfeed/festival.dart';
import 'package:android_app/widgets/newsfeed/manmade.dart';
import 'package:android_app/widgets/newsfeed/special_interest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final User user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((data) {
      setState(() {
        userData = data.data();
      });
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        toolbarHeight: 80,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Icon(
            Icons.account_circle,
            color: Colors.blue,
            size: 50,
          ),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
            color: Colors.amber[500],
            iconSize: 19,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, top: 30, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore",
              style: GoogleFonts.nunitoSans(
                  fontSize: 40, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CulturalNewsfeedWidget()));
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/cultural_background.jpg'))),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(200, 255, 255, 255),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            height: 30,
                            alignment: Alignment.center,
                            child: const Text(
                              "Cultural",
                              style: TextStyle(fontSize: 17),
                            )),
                      ),
                    ),
                  ),
                  Container(
                    color: Color.fromARGB(0, 255, 255, 255),
                  ),
                  Container(
                    color: Color.fromARGB(0, 255, 255, 255),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ManMadeNewsfeedWidget()));
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/manmade_background.jpg'))),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(200, 255, 255, 255),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            height: 30,
                            alignment: Alignment.center,
                            child: const Text(
                              "Man Made",
                              style: TextStyle(fontSize: 17),
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SpecialInterestNewsfeedWidget()));
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/manmade_background.jpg'))),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(200, 255, 255, 255),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            height: 30,
                            alignment: Alignment.center,
                            child: const Text(
                              "Special Interest",
                              style: TextStyle(fontSize: 17),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
            // Expanded(child: ListView.builder(itemBuilder: ((context, index) {

            // }),))
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22, color: Colors.white),
        backgroundColor: Colors.blue,
        curve: Curves.bounceIn,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
              child: const FaIcon(FontAwesomeIcons.map), label: 'Open Maps'),
          SpeedDialChild(
              child: const Icon(Icons.logout), label: 'Logout', onTap: signOut),
        ],
      ),
    );
  }
}
