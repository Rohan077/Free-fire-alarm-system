import 'dart:ui';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:map_launcher/map_launcher.dart';

class Notify extends StatefulWidget {
  const Notify({Key? key, required this.payload}) : super(key: key);

  final String payload;

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSheet = true;
  final int _duration = 10;
  final CountDownController _controller = CountDownController();

  _callNumber() async {
    const number = '08133811679'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    openMapsSheet(context) async {
      try {
        final coords = Coords(30.757874476513337, 76.79645269376289);
        final title = "Sector-3, Chandigarh";
        final availableMaps = await MapLauncher.installedMaps;

        isSheet
            ? showModalBottomSheet<void>(
                enableDrag: true,
                isDismissible: false,
                elevation: 5,
                backgroundColor: Colors.red.shade100,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () {
                      Navigator.pop(context, false);
                      _controller.resume();
                      //we need to return a future
                      return Future.value(false);
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            for (var map in availableMaps)
                              ListTile(
                                onTap: () => map.showMarker(
                                  coords: coords,
                                  title: title,
                                  description: "Fire Occurred!",
                                ),
                                trailing: Icon(
                                  Icons.local_fire_department,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  "Check Location",
                                  softWrap: true,
                                ),
                                leading: InkWell(
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.red,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _controller.resume();
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : _controller.resume();
      } catch (e) {
        print(e);
        print("closed");
      }
    }

    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 15,
      //   elevation: 5,
      //   title: Text("Rush Rush Rush!"),
      //
      // ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/fffg.jpg"),
          fit: BoxFit.cover,
        )),
        child: BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Center(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xffD73502),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Calling Emergency in...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _controller.pause(),
                    onDoubleTap: () => _controller.resume(),
                    child: CircularCountDownTimer(
                      duration: _duration,
                      initialDuration: 0,
                      controller: _controller,
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.height / 2.5,
                      ringColor: Colors.grey[200]!,
                      ringGradient: null,
                      fillColor: Colors.redAccent.shade100,
                      fillGradient: null,
                      backgroundColor: Color(0xffD73502),
                      backgroundGradient: null,
                      strokeWidth: 20.0,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                          fontSize: 33.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textFormat: CountdownTextFormat.S,
                      isTimerTextShown: true,
                      autoStart: true,
                      onComplete: () {
                        _callNumber().then(Navigator.pop(context));
                      },
                      isReverse: true,
                      isReverseAnimation: true,
                    ),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      _controller.pause();
                      // Navigator.pop(context);
                      Vibrate.feedback(FeedbackType.success);
                      openMapsSheet(context);
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => MapState()));
                    },
                    label: Text("Tap For " + widget.payload),
                    icon: Icon(Icons.cancel),
                    backgroundColor: Color(0xffD73502),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.red.shade100,
      // floatingActionButton:
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
