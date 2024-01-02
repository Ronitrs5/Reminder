import 'package:flutter/material.dart';
import 'package:reminder/details_household.dart';
import 'package:reminder/details_study_work.dart';
import 'package:reminder/fragments/oneday.dart';
import 'package:reminder/fragments/threeday.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SevenDay extends StatefulWidget {
  const SevenDay({super.key});

  @override
  State<SevenDay> createState() => _SevenDayState();
}

class _SevenDayState extends State<SevenDay> {

  @override
  void initState(){
    super.initState();
    retrieveUserName();
    _loadTaskAddedCount();
    _loadTaskCompletedCount();
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

  String? userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Column(

        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Card(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36, 12, 36, 12),
                    child: Text("Hello $userName",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'NamunGothic',
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Divider(height: 1,),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text("Track your progress",
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Study and Work',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: CircularProgressIndicator(
                                color: completed / taskAdded >=0.8? Colors.green : completed / taskAdded >=0.5 ?  const Color(
                                    0xBCECC000) : completed / taskAdded >= 0.25 ? Colors.deepOrange : Colors.red[900],
                                backgroundColor: Colors.blueGrey,
                                value: taskAdded == 0? 0 :completed / taskAdded,
                                strokeWidth: 22,
                              ),
                            ),
                            Text( taskAdded == 0 ? "No data":
                              '$completed / $taskAdded',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailsStudyWork()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87 // Change the color to your desired background color
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View details', style: TextStyle(color: Colors.white),),
                              Icon(Icons.arrow_right, color: Colors.white,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Household Chores',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: CircularProgressIndicator(
                                color: taskcompleted_hh / taskadded_hh >=0.8? Colors.green : taskcompleted_hh / taskadded_hh >=0.5 ?  const Color(
                                    0xBCECC000) : taskcompleted_hh / taskadded_hh >= 0.25 ? Colors.deepOrange : Colors.red[900],
                                backgroundColor: Colors.blueGrey,
                                value: taskadded_hh == 0? 0 :taskcompleted_hh / taskadded_hh,
                                strokeWidth: 22,
                              ),
                            ),
                            Text( taskadded_hh == 0? 'No data' :
                              '$taskcompleted_hh / $taskadded_hh',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),


                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailsHousehold()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87 // Change the color to your desired background color
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View details', style: TextStyle(color: Colors.white),),
                              Icon(Icons.arrow_right, color: Colors.white,),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Divider(height: 1,),
          ),

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          //   child: Text("Tasks not completed",
          //     style: TextStyle(
          //         color: Colors.white
          //     ),
          //   ),
          // ),

        ],
      ),
    );
  }

  Future<void> retrieveUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name');

    });

  }


}
