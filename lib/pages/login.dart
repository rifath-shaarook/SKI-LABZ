
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'dart:convert';
import 'register.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:device_id/device_id.dart';






class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _username=TextEditingController();
  var _password =TextEditingController();
  var _formKey=GlobalKey<FormState>();
  var _scaffoldKey =GlobalKey<ScaffoldState>();
  String error='';
  var id;
  
  
  bool isError=false;
  bool isLoading=false;
//final messaging=FirebaseMessaging();
_launch()async{
  var url='https://skilabz.in/product/ski-squad-membership/';
  if(await canLaunch(url)){
     await launch(url);

  }


}
 get_id(){
  var messaging=FirebaseMessaging();
  
  messaging.getToken().then((id){
    id=id;
    print(id);
    return id;
    

  });
}
 

@override
void initState(){
  
  super.initState();
  get_id();
  print(id);
  
}

  _login(String email, String pass) async{
  
  http.post('https://skilabz.in/api/user/generate_auth_cookie/',body: {'email':email,'password':pass}).then((response)async{
   
        if(response.statusCode ==200 && jsonDecode(response.body)['status']  == 'ok') {
          print(jsonDecode(response.body)['cookie']);
           var prefs = await SharedPreferences.getInstance();
             await prefs.setString('cookie',jsonDecode(response.body)['cookie']);
      
  
      await prefs.setString('email', jsonDecode(response.body)['user']['email']);
      await prefs.setString('username', jsonDecode(response.body)['user']['username']);
      await prefs.setInt('pk', jsonDecode(response.body)['user']['id']);
      var messaging=FirebaseMessaging();
      
      messaging.getToken().then((id){
        var params={
        'user_email':prefs.getString('email'),
        'device_token':id,
        'subscribed':'skilabz'
      };
        http.get(Uri(scheme:'https',host: 'skilabz.in',path: 'wp-json/pd/fcm/subscribe/',queryParameters: params)).then((response){
        print(response.body);
      });

      });


      
      
    
          setState(()  {
           
                 Navigator.pushReplacement(context, MaterialPageRoute(
                   builder: (BuildContext context) => HomePage()
                 ));
              


  });

           
     

                  
             


       
    
          
        
        }
 else{



   setState(() {
     isError=true;
     isLoading=false;
   });
 }

        });
 
  
}

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        
      child: new Stack(fit: StackFit.expand, children: <Widget>[
        new Image(
          image: AssetImage('images/splash.jpg'),
          
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),

        
        new Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: new InputDecorationTheme(
                // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                labelStyle:
                    new TextStyle(color: Colors.yellow, fontSize: 20.0),
              )),
          isMaterialAppTheme: true,
          child: new ListView(
         
            children: <Widget>[

              isError ? Container(
                child: Text("Email or Password is Incorrect"),
                color: Colors.red,
              ):Container(),
             
              new Container(
                padding: const EdgeInsets.all(40.0),
                child: new Form(
                  key: _formKey,
                  
                  
                  
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 30.0),
                        child:new TextFormField(
                        
                        controller: _username,
                        decoration: new InputDecoration(
                            labelText: "Email", fillColor: Colors.yellow, border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    )), 
                            
                            
                          
                          validator: (String value){
                            if(value.isEmpty){
                              return  "This field cannot be Empty";
                            }
                          },
                      ),
                      ),
                     Container(
                       
                       padding: EdgeInsets.only(top: 30.0),
                       child: new TextFormField(
                        
                        controller: _password,
                        decoration: new InputDecoration(
                          labelText: "Enter Password",
                          fillColor: Colors.yellow,
                           border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                      
                    ),
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Password cannot  be empty";
                          }
                        },
                      ),
                     ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                      ),
                      isLoading ? CircularProgressIndicator():new MaterialButton(
                        height: 50.0,
                        minWidth: 150.0,
                        color: Colors.teal,
                        splashColor: Colors.blue,
                        textColor: Colors.white70,
                        child:Text("LOGIN"),
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            setState(() {
                                isLoading=true;
                            });
                          
                           _login(_username.text, _password.text);
                          }
                           

                          
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(top:30),
                        margin: EdgeInsets.only(left: 30.0,right: 30.0),
                   
                        child:FlatButton(
                          
                          child: Text("JOIN SKI SQUAD "),
                          onPressed: () {
                            launch('https://skilabz.in/product/ski-squad-membership/',);
                          
                           
                          },
                        )
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30.0),
                        margin: EdgeInsets.only(left: 30.0,right: 30.0),
                        child: FlatButton(
                          child: Text("FORGOT PASSWORD ?"),
                            onPressed: (){
                              launch("https://skilabz.in/account/?action=lostpassword");
                            },

                      ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    ),
    );
}
}