import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';




class Detail extends StatefulWidget {
  final   id;
  final title;
  Detail(this.id,this.title);
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  var body='';
var url;
  bool isLoaded=false;
  fetch(){
    SharedPreferences.getInstance().then((prefs){
      http.post('https://skilabz.in/api/get_post/',body:{'cookie':prefs.getString('cookie'),'id':widget.id}).
      then((response){
          if(response.statusCode == 200 && jsonDecode(response.body)['status'] == 'ok' ){
             
             setState(() {
            body=jsonDecode(response.body)['post']['content'];
              
              url=jsonDecode(response.body)['url'] as List;
              print(url);
              print(body);
         
               isLoaded=true;
             });

          }

      });



    });
  }
  Future<void> refresh(){
    fetch();

  }


  parsetext(var text){
     
 var q= text.replaceAll('<p>','');
  var r =q.replaceAll('</p>','');
  
  return r;
  }
  @override 
  void initState(){
    super.initState();
    fetch();

  }

  @override
  Widget build(BuildContext context) {
    return 
    
    RefreshIndicator(
      onRefresh:refresh ,
      
      child:Scaffold(
      appBar: AppBar(
        title: isLoaded ? Text(widget.title.toString()): Text("Loading"),
        centerTitle: true,
        backgroundColor: Colors.yellow[700],

      ),
      body: isLoaded ? ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
            margin: EdgeInsets.only(top: 5.0),
            child: Html(
              data: body,
              useRichText: true,
              onLinkTap:(url) =>launch(url),
            ),
          )

        ],
      ):Center(child: CircularProgressIndicator())));
}
}

