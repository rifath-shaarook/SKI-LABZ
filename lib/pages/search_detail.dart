import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'post_detail.dart';

class SearchDetail extends StatefulWidget {
  var text;
  SearchDetail(this.text);
  @override
  _SearchDetailState createState() => _SearchDetailState();
}



class _SearchDetailState extends State<SearchDetail> {
List post=[];
bool isLoaded=false;
var count;
@override
void initState(){
super.initState();
get_post(widget.text);

}


 parser(var text){
 var q= text.replaceAll('<p>','');
  var r =q.replaceAll('</p>','');
  
  return r;


}

Widget show_image(List assets){
return  Column(
  children:assets.map((item){
    return  Image.network(item['images']['thumbnail']['url']);
    

  }).toList()
);

}
Widget card(List post){

  return Container(
    child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
      
      
   
      children: post.map((item){
        
        
        return  Container(
          padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 10.0),
          margin: EdgeInsets.symmetric(vertical: 20.0),
        
          
          child: Card(
            elevation: 100,
            child: InkWell(
              onTap: () {
                setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Detail(item['id'].toString(),item['title'].toString())));
                  
                });
                
                
                
                },
              child:Column(
                mainAxisSize: MainAxisSize.min,
                
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 10.0),
                    child: item['attachments'].length != 0 ? show_image(item['attachments']):Image.asset("images/space.jpg"),
                  ),
                 
                  Container(
                    padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 10.0),
                    child:Text(item['title'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),) ,

                  ),
                   Divider(
                    color: Colors.white70,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8.0,right:8.0,top: 10.0 ),
                    child: Text( parser(item['excerpt']).toString()),

                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    children: <Widget>[
                       Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 10.0),
                    child: Text(item['date'].toString(),style: TextStyle(color: Colors.grey,fontSize: 10.0),),

                  ),

                    ],
                  )
                 
                  
                  
              
                  
                
                ],
              )
            ),
          ),

        );
      





      }).toList()
    ),
  );





}

get_post(var text){
  SharedPreferences.getInstance().then((prefs){
    http.post('https://skilabz.in/api/get_search_results/',body: {'cookie':prefs.getString('cookie'),'search':text}).then((response){
      if(response.statusCode == 200 &&jsonDecode(response.body)['status'] == 'ok' ){
        setState(() {
          isLoaded=false;
        });
        post.add(jsonDecode(response.body)['posts']);
        print(post);
        count=jsonDecode(response.body)['count'];
        setState(() {
          isLoaded=true;
          
        });

      }


    });

  });

}  
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image(
          fit: BoxFit.cover,
          image: AssetImage("images/splash.jpg"),
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),

        Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.yellow[700],
         centerTitle: true,
        title: Text(widget.text),
       ), 

      body:
      Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black87,
           
            image:AssetImage('images/sketch.jpg'),
          ),
           

         count !=0 ? isLoaded ? ListView.builder(
        itemCount: post.length,
        itemBuilder: (BuildContext context,int i){
          return card(post[i]);
        },
      ):  Center(child: CircularProgressIndicator()): Center(child: Text("No search results found",style: TextStyle(fontSize: 20.0,color: Colors.red),),) 

        ],
      )
        
    )

      ],
    );
    
     
    
    

  }
}