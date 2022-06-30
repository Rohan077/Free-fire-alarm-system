import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

import 'getLocation.dart';
import 'notify.dart';

String? update = "  Chandigarh";
final myController = TextEditingController(text: update);
_callNumber() async {
  const number = '08133811679'; //set the number here
  await FlutterPhoneDirectCaller.callNumber(number);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title}) : super();
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BigPictureStyleInformation styleInform = BigPictureStyleInformation(
    DrawableResourceAndroidBitmap("fffg"),
    contentTitle: "Location - Sector 3, Chandigarh",
    htmlFormatContentTitle: true,
    largeIcon: DrawableResourceAndroidBitmap("app_icon"),
    htmlFormatContent: true,
  );

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
  }

  @override
  initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('firefighter');
    var iosInitialize = new IOSInitializationSettings();
    var initializeSettings = new InitializationSettings(
        android: androidInitialize, iOS: iosInitialize);
    _flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onSelectNotification: notificationSelection,
    );
    myController.addListener(() {
      //here you have the changes of your textfield
      // myController.clear();
      print("value: ${myController.text}");
      //use setState to rebuild the widget
      setState(() {});
    });
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channel Description',
      importance: Importance.max,
      styleInformation: styleInform,
      color: Colors.red,
      autoCancel: true,
      enableVibration: true,
    );
    var iosDetails = new IOSNotificationDetails();
    var generalNotifications =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _flutterLocalNotificationsPlugin.show(
        0, "Fire Alert!", "Rush Immediately!", generalNotifications,
        payload: "Location - Sector 3, Chandigarh");
  }

  Future notificationSelection(String? payload) async {
    await Navigator.push(
        context,
        PageTransition(
            child: Notify(
              payload: payload ?? "null",
            ),
            type: PageTransitionType.bottomToTop)
        // MaterialPageRoute(
        //   builder: (context) => Notify( payload: payload??"null",),
        // ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Drawer(
            backgroundColor: Colors.red.shade50,
            child: DrawerHeader(
              child: Container(
                child: Center(child: Text("Welcome to free!")),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.red.shade50,
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                child: Icon(Icons.notifications_active),
                onTap: () {
                  _showNotification()
                      .then((value) => Vibrate.feedback(FeedbackType.warning));
                },
              ),
            )
          ],
          backgroundColor: Color(0xffD73502),
          shadowColor: Colors.redAccent.shade100,
          elevation: 5,
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40))),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          // padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                // color: Color(0xffD73502),
                shadowColor: Colors.redAccent.shade100,
                elevation: 5,
                child: TextFormField(
                  cursorColor: Color(0xffD73502),
                  // initialValue: "Love",
                  controller: myController,
                  onFieldSubmitted: (text) => setState(() {
                    print(text);
                    myController.text = text;
                    print(myController.text);
                  }),
                  // initialValue: "myController.text",
                  decoration: InputDecoration(
                    prefixIconColor: Color(0xffD73502),
                    suffixIconColor: Color(0xffD73502),
                    labelText: 'Search Location',
                    hintText: "Enter a city",
                    border: OutlineInputBorder(
                    ),
                    focusColor: Color(0xffD73502),
                    fillColor: Color(0xffD73502),
                    hoverColor: Color(0xffD73502),
                    iconColor: Color(0xffD73502),
                    suffixIcon: Icon(
                      Icons.location_on,
                    ),
                  ),
                ),
              ),
              FutureBuilder<List<Images>>(
                future: fetchPhotos(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? PhotosList(photos: snapshot.data!)
                      : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CircularProgressIndicator(color: Color(0xffD73502),),
                      );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(

          onPressed: () async {
            _callNumber();
          },
          icon: Icon(
            Icons.local_hospital_outlined,
          ),
          elevation: 5,
          label: Text("SOS"),
          backgroundColor: Color(0xffD73502),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
