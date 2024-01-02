import 'package:flutter/material.dart';
import 'package:reminder/fragments/sevenday.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

int taskadded_hh = 0;
int taskcompleted_hh = 0;

class ThreeDay extends StatefulWidget {
  const ThreeDay({super.key});

  @override
  State<ThreeDay> createState() => _ThreeDayState();
}

class _ThreeDayState extends State<ThreeDay> {

  TimeOfDay selectedTime = TimeOfDay.now();



  final TextEditingController _textFieldController = TextEditingController();
  List<String> _tasks_hh = [];
  List<String> removedTasks_hh = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadTaskAddedCount();
    _loadTaskCompletedCount();
    _initializeNotifications();
    // tz.initializeTimeZones();
    _loadRemovedTasks();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _setReminder(String task, TimeOfDay selectedTime) async {
    String formattedTime = DateFormat.Hm().format(
      DateTime(2022, 1, 1, selectedTime.hour, selectedTime.minute),
    );

    // Schedule a reminder/notification
    await _scheduleNotification(task, formattedTime);

    Navigator.pop(context); // Close the bottom sheet
  }

  Future<void> _scheduleNotification(String task, String formattedTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'alarm_channel_id',
      'alarm_channel_name',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      onlyAlertOnce: true, // Set onlyAlertOnce to true for inexact alarms
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Use a unique notification ID based on the task or a timestamp
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Schedule the notification for the same time every day
    DateTime now = DateTime.now();
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // If the scheduled time is before the current time, schedule it for the next day
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Alarm',
      'Time to complete your task "$task" at $formattedTime!',
      scheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Use inexact alarm
    );
  }



  List<Widget> _buildTaskWidgets() {
    return _tasks_hh.map((task) {
      return GestureDetector(
        onTap: () => _showTaskDetails(task),
        child: Card(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: () {
                    _removeTask2(task);
                  },
                ),
                Expanded(
                  child: Text(
                    task,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.check_circle),
                  color: Colors.green,
                  onPressed: () {
                  _removeTask(task);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _loadTaskAddedCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      taskadded_hh = prefs.getInt('taskAdded_hh') ?? 0;
    });
  }

  Future<void> _loadTaskCompletedCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      taskcompleted_hh = prefs.getInt('task_completed_hh') ?? 0;
    });
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks_hh = prefs.getStringList('tasks_hh') ?? [];
    });
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks_hh', _tasks_hh);
    taskadded_hh++;
    prefs.setInt('taskAdded_hh', taskadded_hh);
  }

  Future<void> _removeTask(String task) async {

    setState(()  {
      _tasks_hh.remove(task);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks_hh', _tasks_hh);
    taskcompleted_hh++;
    prefs.setInt('task_completed_hh', taskcompleted_hh);
  }

  Future<void> _removeTask2(String task) async {

    setState(()  {
      _tasks_hh.remove(task);
      removedTasks_hh.add(task); // Append the removed task to the list
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks_hh', _tasks_hh);
    prefs.setInt('task_completed_hh', taskcompleted_hh);
    prefs.setStringList('removed_tasks_hh', removedTasks_hh);
  }

  Future<void> _loadRemovedTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      removedTasks_hh = prefs.getStringList('removed_tasks_hh') ?? [];
    });
  }


  Future<void> _showInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Task'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Task for today...'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _textFieldController.clear();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String inputValue = _textFieldController.text.trim();

                if(inputValue.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task cannot be empty')));
                  _textFieldController.clear();
                }

                if (inputValue.isNotEmpty) {
                  setState(() {
                    _tasks_hh.add(inputValue);
                    _saveTasks();
                    _textFieldController.clear();
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> infoBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xff554e6b),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Add tasks which are related to: \n 1. Household works\n 2. Cleaning tasks\n 3. Personal tasks\n 4. Any appointments\n\n"
                  "This will help you to track and monitor your professional and your household tasks separately.\n\n"
                  "NOTE:\nThe RED button at the starting will remove the task and mark it as INCOMPLETE, whereas the GREEN button at the end will remove the task and mark it as COMPLETE.",

              style: TextStyle(color: Colors.white,
                fontFamily: 'NamunGothic'
              ),
              textAlign: TextAlign.start,
            ),

          ),
        );
      },
    );
  }





  Future<void> _showTaskDetails(String task) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Set this property to true
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xff554e6b),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum height
              children: [

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                    border: Border.all(
                      color: Colors.black54,
                      width: 2.0, // Adjust the border width as needed
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      task,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NamunGothic',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),
                //
                // GestureDetector(
                //   onTap: () async {
                //     TimeOfDay? pickedTime = await showTimePicker(
                //       context: context,
                //       initialTime: selectedTime,
                //     );
                //
                //     if (pickedTime != null && pickedTime != selectedTime) {
                //       setState(() {
                //         selectedTime = pickedTime;
                //       });
                //     }
                //   },
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.baseline,
                //     textBaseline: TextBaseline.alphabetic,
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Text(
                //         'Selected Time',
                //         style: const TextStyle(color: Colors.white, fontFamily: 'NamunGothic', fontSize: 16),
                //       ),
                //       Container(
                //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
                //         decoration: BoxDecoration(
                //           color: Colors.black54, // Set your desired box color
                //           borderRadius: BorderRadius.circular(16.0), // Set your desired border radius
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             '${selectedTime.format(context)}',
                //             style: const TextStyle(
                //               color: Colors.white, // Set your desired text color inside the box
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //     ],
                //   ),
                // ),
                //
                //
                //
                // const SizedBox(height: 16.0),
                //
                // ElevatedButton(
                //   onPressed: () async {
                //     // Perform actions with the task and selected time
                //     String formattedTime = DateFormat.Hm().format(
                //       DateTime(
                //         DateTime.now().year,
                //         DateTime.now().month,
                //         DateTime.now().day,
                //         selectedTime.hour,
                //         selectedTime.minute,
                //       ),
                //     );
                //     print('Task: $task, Selected Time: $formattedTime');
                //
                //     // Set the reminder/notification
                //     await _setReminder(task, selectedTime);
                //
                //     Navigator.pop(context); // Close the bottom sheet
                //
                //     // Show a Snackbar
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text('Reminder set successfully!'),
                //         duration: Duration(seconds: 2), // Adjust the duration as needed
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.black54, // Set your desired background color
                //   ),
                //   child: const Text('Remind me', style: TextStyle(color: Colors.white)),
                // ),



              ],
            ),
          ),
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Column(

        children:
        [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Visibility(
              visible: _tasks_hh.isEmpty,
              child: Column(
                children: [
                  const Text(
                    'No tasks added. Click the plus button to add a task.\n',
                    style: TextStyle(color: Colors.white),
                  ),

                  IconButton(
                    onPressed: (){
                      infoBottomSheet();
                    },
                    icon: const Icon(Icons.info),
                    color: Colors.white,
                  )

                ],
              ),
            ),
          ),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: _buildTaskWidgets(),
              ),
            ),
          ),


          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: FloatingActionButton(
          //         onPressed: () {
          //           _showInputDialog(context);
          //         },
          //         backgroundColor: const Color(0xff554e6b),
          //         child: const Icon(Icons.add, color: Colors.white),
          //       ),
          //     ),
          //
          //     Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: FloatingActionButton(
          //         onPressed: () {
          //           _showInputDialog(context);
          //         },
          //         backgroundColor: const Color(0xff554e6b),
          //         child: const Icon(Icons.person, color: Colors.white),
          //       ),
          //     ),
          //
          //   ],
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _showInputDialog(context);
                  },
                  backgroundColor: const Color(0xff554e6b),
                  child: const Icon(Icons.settings, color: Colors.white),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _showInputDialog(context);
                  },
                  backgroundColor: const Color(0xff554e6b),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SevenDay()));
                  },
                  backgroundColor: const Color(0xff554e6b),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
