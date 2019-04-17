import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_detail.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final  _controller=TextEditingController();





  
  @override
  Widget build(BuildContext context) {
  
    return Stack(
      fit: StackFit.expand,


      children: <Widget>[
        Image(
          fit: BoxFit.cover,
          image: AssetImage("images/sketch.jpg"),
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),

         Scaffold(
           appBar: AppBar(
             title: Text("Search"),
             backgroundColor: Colors.yellow[700],
             centerTitle: true,
           ),
           body:  Stack(
             fit: StackFit.expand,
             children: <Widget>[

               Image(
                 fit: BoxFit.cover,
                 colorBlendMode: BlendMode.darken,
                 color: Colors.black54,
                 image: AssetImage("images/sketch.jpg"),
               ),

               Column(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[

                   Flexible(

                     child: TextFormField(
                       controller: _controller,
                       decoration: InputDecoration(
                         labelText: "Enter a search term",
                         hasFloatingPlaceholder: true,
                         labelStyle: TextStyle(color: Colors.yellow,fontSize: 20.0)
                       ),
                       
                     ),
                     
                   ),
                   Container(
                     padding: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                     margin: EdgeInsets.only(top: 10.0),
                     child: RaisedButton(
                       child: Text("Search"),
                       color: Colors.yellow,
                       splashColor: Colors.yellow,
                       onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchDetail(_controller.text))),
                     ),
                   )


                 ],
               )


             ],
           ),
         ),
         

      ],
    );
      
    
    
  }
}