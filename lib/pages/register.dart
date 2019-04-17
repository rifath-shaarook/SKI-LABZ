import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
   return WebviewScaffold(
      appBar: AppBar(
        title: Text("REGISTER"),
      
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      url:'https://skilabz.in/product/ski-squad-membership/',
      withJavascript: true,
      
    );
      
}
}