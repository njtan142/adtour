import 'package:android_app/widgets/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConfigurationWidget extends StatefulWidget {
  final String uid;
  const ConfigurationWidget({super.key, required this.uid});

  @override
  State<ConfigurationWidget> createState() => _ConfigurationWidgetState();
}

class _ConfigurationWidgetState extends State<ConfigurationWidget> {
  bool isInternational = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2176C6),
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/almost_there.svg'),
              const SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                          fillColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          value: isInternational,
                          onChanged: (value) {
                            setState(() {
                              isInternational = !isInternational;
                            });
                          }),
                      Text(
                        'Are you an ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'International Tourist?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select your country ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      LocationsSelection(
                          locations: ['USA', 'Africa', 'Indonesia'])
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                          fillColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          value: !isInternational,
                          onChanged: (value) {
                            setState(() {
                              isInternational = !isInternational;
                            });
                          }),
                      Text(
                        'Are you a ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        'Local Tourist?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select your country ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      LocationsSelection(
                          locations: ['Cordova', 'Cebu', 'Siargao'])
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70, right: 70),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('admin')
                                .doc('analytics')
                                .get()
                                .then((analyticsReference) {
                              Map<String, dynamic> data = {};
                              final String tourist =
                                  !isInternational ? 'local' : 'international';
                              if (analyticsReference.data() != null) {
                                data = analyticsReference.data()
                                    as Map<String, dynamic>;
                              }
                              if (data[tourist] != null) {
                                data[tourist] += 1;
                              } else {
                                data[tourist] = 1;
                              }
                              FirebaseFirestore.instance
                                  .collection('admin')
                                  .doc('analytics')
                                  .set(data, SetOptions(merge: true))
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.uid)
                                    .set({
                                  'tourist_type': !isInternational
                                      ? 'local'
                                      : 'international'
                                }, SetOptions(merge: true)).then((value) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SplashScreen()));
                                });
                              });
                            });
                          },
                          child: Text(
                            "CONTINUE",
                            style: TextStyle(
                                color: Color(0xFF4C9EEB), fontSize: 18),
                          )),
                    )),
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class LocationsSelection extends StatefulWidget {
  final List<String> locations;
  const LocationsSelection({super.key, required this.locations});

  @override
  State<LocationsSelection> createState() => _LocationsSelectionState();
}

class _LocationsSelectionState extends State<LocationsSelection> {
  String dropdownValue = "";

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      dropdownValue = widget.locations.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(
        color: Colors.white,
      ),
      dropdownColor: Colors.blue,
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: widget.locations.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
