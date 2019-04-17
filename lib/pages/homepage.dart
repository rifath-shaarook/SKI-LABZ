import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'dart:convert';
import 'package:skilabz/pages/post_detail.dart';
import 'search.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';






class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
 String username='';
String email='';
String cookie='';
List post=[];
List post1=[];
List post2=[];
int count_1=1;
bool isLoaded=false;
bool isLoaded1=false;
bool isLoaded2=false;
int count_2=1;
var amap={};
Color c1= Color(0XFFB606);



_initizalize(){
  SharedPreferences.getInstance().then((prefs){
    setState(() {
    username=prefs.getString('username');
  
    email=prefs.getString('email');
  
    cookie=prefs.getString('cookie');
    
    });
    
  });

}
fetchpost() async{
  SharedPreferences.getInstance().then((prefs){

 http.post('https://skilabz.in/api/get_posts/',
 body:{'cookie':prefs.getString('cookie')},//Cookie must be sent directly
 
 
 ).then((response){
   print(response.statusCode);
   if(response.statusCode == 200){
    
     
     

   }
 });


  });

}

discover(){
  SharedPreferences.getInstance().then((prefs){

http.post('https://skilabz.in/api/get_category_posts/',body:{'slug':'Discover','cookie': prefs.getString('cookie'),'page':count_1.toString()}).then((response){
  if(response.statusCode ==200  && jsonDecode(response.body)['status'] == 'ok'){

      setState(() {
      post.add(jsonDecode(response.body)['posts']);
      
      isLoaded=true;
     

      });
     
     

     

     
     
    

  }


});


  });
}

 parser(var text){
 var q= text.replaceAll('<p>','');
  var r =q.replaceAll('</p>','');
  
  return r;


}
noob(){

  SharedPreferences.getInstance().then((prefs){

http.post('https://skilabz.in/api/get_category_posts/',body:{'slug':'noob','cookie': prefs.getString('cookie'),'page':count_1.toString()}).then((response){
  if(response.statusCode ==200  && jsonDecode(response.body)['status'] == 'ok'){

      setState(() {
      post2.add(jsonDecode(response.body)['posts']);
      
      isLoaded2=true;
     

      });
     
     

     

     
     
    

  }


});


  });


}



makeit(){
  SharedPreferences.getInstance().then((prefs){

http.post('https://skilabz.in/api/get_category_posts/',body:{'slug':'make','cookie': prefs.getString('cookie'),'page':count_2.toString()}).then((response){
  if(response.statusCode ==200  && jsonDecode(response.body)['status'] == 'ok'){

 
     
    setState(() {
      post1.add(jsonDecode(response.body)['posts']);
      isLoaded1=true;
    });
     
   
    

     
     
    

  }


});


  });


}




@override
void initState(){
  super.initState();
  _initizalize();
  fetchpost();
  makeit();
  discover();
  noob();
  
  
}



Future <Null> refresh1() async{
  
    setState(() {
      post.clear();
      isLoaded=false;
     
  
      
    });
     discover();
    return null;
    
  

  
}
Future<Null> refresh2()async{
  
    
     setState(() {
       post1.clear();
       isLoaded1=false;
        
        
       
     });
       makeit();
     return null;
  
    

}
Future<Null> refresh3()async{
  
    
     setState(() {
       post2.clear();
       isLoaded2=false;
        
        
       
     });
       noob();
     return null;
  
    

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
  showlogout(context){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      
      return  AlertDialog(
      
      title: Text(" Logout"),
      content: Text("Are you Sure want to Logout"),
      titleTextStyle: TextStyle(color: Colors.blue),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),

          onPressed: (){
            SharedPreferences.getInstance().then((prefs){
              prefs.remove('username');
              prefs.remove('email');
              prefs.remove('pk');
              prefs.remove('cookie');
              var messaging=FirebaseMessaging();
              messaging.getToken().then((id){
                http.post('https://skilabz.in/wp-json/pd/fcm/unsubscribe/',body:{'unsubscribe':'yes','device_id':id});

              });

              setState(() {
                 Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) =>LoginPage()
              ));
                
              });
             
              
            

            });
            
          },
        ),
        FlatButton(
          child: Text("No"),
          color: Colors.white,
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
      ],
    
      );
    }
  );


}
Widget show_image(List assets){
return  Column(
  children:assets.map((item){
    return  Image.network(item['images']['thumbnail']['url']);
    

  }).toList()
);

}
  @override
  Widget build(BuildContext context) {
    return  Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image(
            fit: BoxFit.fill,
            colorBlendMode: BlendMode.darken,
            color: Colors.black54,
            image:AssetImage('images/splash.jpg'),
          ),


         DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[700],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>SearchPage())),
            ),
          ],
         
        ),
        drawer:Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                
                accountName: Text(username,style: TextStyle(color: Colors.black),),
                accountEmail: Text(email,style: TextStyle(color: Colors.black),),
                decoration: BoxDecoration(
                  
                  color: Colors.yellow[700]
  
                ),
                
                currentAccountPicture: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage("images/logo.png")
                  ,
                ),
              ),
              ListTile(
                leading: Icon(Icons.contacts,color: Colors.black,),
                title: Text("ContactUs"),
                onTap: () => launch('https://skilabz.in/contact/'),
              ),


               ListTile(
                leading: Icon(Icons.add_location,color: Colors.black,),
                title: Text("AboutUs"),
                onTap: () => launch('https://skilabz.in/about-us/')
              ),

               ListTile(
                leading: Icon(Icons.question_answer,color: Colors.black,),
                title: Text("FAQS"),
                onTap: () => launch('https://spacekidzindia.in/'),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app,color: Colors.black,),
                title: Text("Logout"),
                onTap: () => showlogout(context),
              ),
              Container(
                margin: EdgeInsets.only(top: 300.0),
              alignment: Alignment.center,
                child: Text("Copyright @ skilabz.in"),
            
          )
              
            ],
             
          ),
         


        ),

      bottomNavigationBar:Stack(
        children: <Widget>[

          
       TabBar(
        tabs: <Widget>[


          
          Tab(
            icon: Icon(Icons.add,color: Colors.black,),
            child: Text("Discover",style: TextStyle(color: Colors.black),),
            
            
          ),
          Tab(
            icon: Icon(Icons.phone_iphone,color: Colors.black,),
            child: Text("MakeIt",style: TextStyle(color: Colors.black),),
            
            
          ),
          Tab(
            icon: Icon(Icons.people_outline,color: Colors.black,),
            child: Text("Noob",style: TextStyle(color: Colors.black),),
            
            
          )
         
        ],
      ), 

        ],
      ),
      
      body:
       Stack(
         fit: StackFit.expand,
         children: <Widget>[
           Image(
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black54,
            image:AssetImage('images/splash.jpg'),
          ),
           

      TabBarView(
        children: <Widget>[

         
           
           RefreshIndicator(
             onRefresh: refresh1,
             child:isLoaded? ListView.builder(
        itemCount: post.length,
        itemBuilder: (BuildContext context ,int i){
  
           
            return card(post[i]);
        },
      ): Center(child:CircularProgressIndicator(valueColor:   new AlwaysStoppedAnimation<Color>(Colors.blue),))),
         
         
       

            
        
      
      RefreshIndicator(
        onRefresh: refresh2,
        child:isLoaded1? ListView.builder(
        itemCount: post1.length,
        itemBuilder: (BuildContext context ,int i){
          
          return  card(post1[i]);
        },
      ): Center(child:CircularProgressIndicator(valueColor:  new AlwaysStoppedAnimation<Color>(Colors.blue) ,))),

           RefreshIndicator(
             onRefresh: refresh3,
             child:isLoaded2? ListView.builder(
        itemCount: post2.length,
        itemBuilder: (BuildContext context ,int i){
  
           
            return card(post2[i]);
        },
      ): Center(child:CircularProgressIndicator(valueColor:   new AlwaysStoppedAnimation<Color>(Colors.blue),))),

        ],


        
      ),


      
  
         ],
       )  
     
      
    )
    )
      
      
        

      ],
    );
    
     
      
  }


}

 

