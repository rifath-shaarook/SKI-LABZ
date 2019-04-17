import 'package:flutter/material.dart';
import 'login.dart';
import 'dart:async';
import 'dart:io';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isConnected=true;     
  checkconnection() async {
    try{
      final result=await  InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        setState(() {
          isConnected=true;
        });
      }
    } on SocketException catch(_){
      setState(() {
        isConnected=false;
      });

    }
  }
 Future <void> check() async {
var prefs= await SharedPreferences.getInstance();
var cookie=prefs.getString('cookie');
if(cookie != null){
  setState(() {
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  });
}
else{
  setState(() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  });
}

}
  @override
  void initState() {
    //checkconnection();
    super.initState();
    Timer(Duration(seconds: 3), check);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black54,
            image:AssetImage('images/splash.jpg'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70.0,
                          child: Image(
                              image: AssetImage(
                                  'images/logo.png'))),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        " SKI LABZ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[700],
                            fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.yellow[700]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'Discover your Curiosity!',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
