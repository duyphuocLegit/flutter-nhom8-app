import 'package:flutter/material.dart';
import 'customText.dart';

Widget upperHeader(
  String txt,
  BuildContext context,
  bool isIcon,
  Widget? page,
) {
  var he = MediaQuery.of(context).size.height;
  return Padding(
    padding: EdgeInsets.only(top: he * 0.03),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            // Fix: Use Navigator.pop() for back button functionality
            if (page != null) {
              // If a specific page is provided, navigate to it
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            } else {
              // Default back button behavior
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.arrow_back_rounded, size: 30, color: Colors.black),
        ),
        SizedBox(width: he * 0.03),
        customText(txt, 28, Colors.black),
        Expanded(child: Container()),
        isIcon
            ? Icon(Icons.search, size: 30, color: Colors.black)
            : Container(),
      ],
    ),
  );
}
