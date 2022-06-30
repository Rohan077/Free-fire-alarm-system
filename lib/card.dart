import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:free_project/getLocation.dart';
import 'package:url_launcher/url_launcher.dart';

class ListCard extends StatefulWidget {
  final String title;
  final String url;
  final String whatsapp;
  final String phone;
  const ListCard({Key? key,required this.title, required this.whatsapp, required this.phone, required this.url}) : super(key: key);

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.redAccent.shade100,
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.all(Radius.circular(5)),
                    color: Color(0xffD73502),
                  ),
                  child: ListTile(
                    leading: Image.asset("images/firefighter.png",scale: 12,),
                    title: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(widget.title,style: TextStyle(color: Colors.white),),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("We fight fire for you!",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Image.network(
                widget.url.isEmpty?"https://www.ssf.net/home/showpublishedimage/3118/636396008145370000":widget.url,
                fit: BoxFit.fill,
                height: 150,
                width: 250,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
              SizedBox(height: 5,),
              ButtonTheme( // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: const Text('Whatsapp',style: TextStyle(color: Colors.green,),),
                      onPressed: () async {
                        await FlutterLaunch.launchWhatsapp(phone: widget.whatsapp, message: "Hey, emergency! A fire broke out at position: $lat, $long.");

                      },
                      shape:
                      RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.green)
                      ),
                      splashColor: Colors.green,
                      autofocus: true,

                    ),
                    SizedBox(width: 0.5,),
                    FlatButton(
                      child: const Text('Call'),
                      color: Color(0xffD73502),
                      onPressed: () {
                        launch("tel://"+widget.phone);
                      }
                    ),
                    SizedBox(width: 0.5,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
