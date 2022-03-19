import 'package:alarm_final/reusable_animation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';


void main(){
  // device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _alarmTime = 'No alarm set';

  var _hour;
  //convert to 12 hour format
  String _convertTo12HourFormat(int hour) {
    String hourString = hour.toString();
    if (hour >= 1 && hour <= 12) {
      hourString = hour.toString();
    } else if (hour > 12) {
      hourString = (hour - 12).toString();
    } else if (hour == 0) {
      hourString = "12";
    }
    return hourString;
  }

  var _minute;
  //convert to 12 hour format
  String _convertTo12HourFormatMinute(int minute) {
    String minuteString = minute.toString();
    if (minute < 10) {
      minuteString = "0" + minute.toString();
    }
    return minuteString;
  }

  // day night time picker

  TimeOfDay _time = TimeOfDay.now().replacing(minute: 30);
  bool iosStyle = true;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  var time;

  getImage() {
    String morningUrl =
        "https://cdn.pixabay.com/photo/2017/02/19/15/28/sunset-2080072_960_720.jpg";
    String afternoonUrl =
        'https://cdn.pixabay.com/photo/2017/08/04/20/28/afternoon-2581381_960_720.jpg';
    String eveningUrl =
        "https://cdn.pixabay.com/photo/2013/07/25/01/33/boat-166738_960_720.jpg";
    String nightUrl =
        "https://cdn.pixabay.com/photo/2016/11/25/23/15/moon-1859616_960_720.jpg";

    var hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return morningUrl;
      // afternoon url

    }
    if (hour >= 12 && hour < 16) {
      return afternoonUrl;
      // evening url

    } else if (hour >= 16 && hour < 18) {
      return eveningUrl;
    } else {
      return nightUrl;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Tushar's Alarm"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ReusableAnimation(
              child: Image.network(
                getImage(),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SlideInUp(
                delay: Duration(seconds: 2),
                duration: Duration(seconds: 1),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    //box shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          //_time.format(context),
                          time == null
                              ? "Please create your alarm"
                              : "${_convertTo12HourFormat(_time.hour)}:${_convertTo12HourFormatMinute(_time.minute)} $time",
                          // am or pm
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          // "Set alarm for $_hour:$_minute",
                          // convert _hour to 12 hour format
                        ),
                        onPressed: () {
                          FlutterAlarmClock.createAlarm(
                            _hour,
                            _minute,
                          );

                          // create alarm for 07: 35 pm
                        },
                      ),
                      Builder(builder: (context) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: onTimeChanged,
                                minuteInterval: MinuteInterval.ONE,
                                disableHour: false,
                                disableMinute: false,
                                minMinute: 0,
                                maxMinute: 56,
                                minHour: 1,
                                // Optional onChange to receive value as DateTime
                                onChangeDateTime: (DateTime dateTime) {
                                  setState(() {
                                    _time = TimeOfDay.fromDateTime(dateTime);
                                    _hour = _convertTo12HourFormat(_time.hour);
                                    _minute = _convertTo12HourFormatMinute(
                                        _time.minute);
                                    //deteremine if am or pm
                                    if (_time.hour > 12) {
                                      time = "pm";
                                    } else {
                                      time = "am";
                                    }

                                    //set alarm for _hour and _minute
                                    FlutterAlarmClock.createAlarm(
                                      _time.hour,
                                      _time.minute,
                                    );
                                  });
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Open time picker",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }),
                      TextButton(
                        child: const Text(
                          'Show alarms',
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                        onPressed: () {
                          FlutterAlarmClock.showAlarms();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Show Timers',
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                        onPressed: () {
                          FlutterAlarmClock.showTimers();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
