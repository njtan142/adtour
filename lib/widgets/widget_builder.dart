import 'package:android_app/widgets/profile/profile_picture_view_widget.dart';
import 'package:flutter/material.dart';

import '../custom_arts.dart';

Widget displayProfile(BuildContext context, Map<String, dynamic> userData) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePictureView(
                profileURL: userData['profile_url'] ??
                    "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
          ));
    },
    child: CircleAvatar(
      child: ClipOval(
        child: userData['profile_url'] == null
            ? Image.network(
                width: 100,
                height: 100,
                "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
                fit: BoxFit.cover,
              )
            : Image.network(
                userData['profile_url'],
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
      ),
    ),
  );
}

Widget createCategoryCard(
    BuildContext context, Widget pageWidget, String category) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => pageWidget));
    },
    child: Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  'assets/${category.toLowerCase().replaceAll(' ', '')}_background.jpg'))),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
            decoration: BoxDecoration(
                color: categoryTextBGColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            height: 30,
            alignment: Alignment.center,
            child: Text(
              category,
              style: const TextStyle(fontSize: 17),
            )),
      ),
    ),
  );
}
