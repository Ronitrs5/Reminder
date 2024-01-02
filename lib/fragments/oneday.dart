import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

int completed = 0;
int taskAdded = 0;
int taskNotDone = 0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OneDay(),
    );
  }
}

class OneDay extends StatefulWidget {
  const OneDay({Key? key});

  @override
  State<OneDay> createState() => _OneDayState();
}

class _OneDayState extends State<OneDay> {

  final TextEditingController _textFieldController = TextEditingController();
  List<String> _tasks = [];
  List<String> removedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadTaskAddedCount();
    _loadTaskCompletedCount();
    _loadRemovedTasks();
  }


  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', _tasks);
    taskAdded++;
    prefs.setInt('taskAdded', taskAdded);
  }

  Future<void> _removeTask(String task) async {

    setState(()  {
      _tasks.remove(task);

    });
    completed++;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', _tasks);
    prefs.setInt('task_completed', completed);
  }

  Future<void> _removeTask2(String task) async {
    setState(() {
      _tasks.remove(task);
      removedTasks.add(task); // Append the removed task to the list
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', _tasks);
    prefs.setInt('task_completed', completed);
    prefs.setStringList('removed_tasks', removedTasks);
  }

  Future<void> _loadRemovedTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      removedTasks = prefs.getStringList('removed_tasks') ?? [];
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
                    _tasks.add(inputValue);
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





  // Future<void> _showTaskDetails(String task) async {
  //   await showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           color: Color(0xff554e6b),
  //           borderRadius: BorderRadius.only(
  //             topLeft: const Radius.circular(10.0),
  //             topRight: const Radius.circular(10.0),
  //           ),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Text(
  //             task,
  //             style: TextStyle(color: Colors.white),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


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
              ],
            ),
          ),
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
            child:   Text(
              "Add tasks which are related to: \n 1. School homeworks\n 2. Pending Assignments\n 3. Exam preparation\n 4. Learning goals\n 5. Office work\n\n"
                  "This will help you to track and monitor your professional and your household tasks separately.\n\n"
                  "NOTE:\nThe RED button at the starting will remove the task and mark it as INCOMPLETE, whereas the GREEN button at the end will remove the task and mark it as COMPLETE.",
              style: TextStyle(color: Colors.white,  fontFamily: 'NamunGothic'),
              textAlign: TextAlign.start,
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
              visible: _tasks.isEmpty,
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
        ],
      ),
    );
  }

  List<Widget> _buildTaskWidgets() {
    return _tasks.map((task) {
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
      taskAdded = prefs.getInt('taskAdded') ?? 0;
    });
  }

  Future<void> _loadTaskCompletedCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      completed = prefs.getInt('task_completed') ?? 0;
    });
  }
}
