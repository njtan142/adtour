import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../map/map_widget.dart';
import '../map/mapbox_widget.dart';

class DestinationInfoWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  const DestinationInfoWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<DestinationInfoWidget> createState() => _DestinationInfoWidgetState();
}

class _DestinationInfoWidgetState extends State<DestinationInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding:
            const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
        child: Column(
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
          ],
        ),
      ))),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22, color: Colors.white),
        backgroundColor: Colors.blue,
        curve: Curves.bounceIn,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
            child: const FaIcon(FontAwesomeIcons.map),
            label: 'Open Maps',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapWidget(
                            latitude: double.parse(widget.data['latitude']),
                            longitude: double.parse(widget.data['longitude']),
                            name: widget.data["name"],
                          )));
            },
          ),
        ],
      ),
    );
  }
}
