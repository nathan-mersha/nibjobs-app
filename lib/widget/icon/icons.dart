import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomIcons {
  static Widget noInternet(){
    return Icon(Icons.cloud_off, size: 50,color: Colors.black54,);
  }

  static Widget getHorizontalLoading(){
    return SpinKitThreeBounce(color: Colors.black54,size: 30,);
  }
}