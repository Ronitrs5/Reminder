import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsHousehold extends StatefulWidget {
  const DetailsHousehold({super.key});

  @override
  State<DetailsHousehold> createState() => _DetailsHouseholdState();
}

class _DetailsHouseholdState extends State<DetailsHousehold> {

  List<String> removedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadRemovedTasks();
  }

  Future<void> _loadRemovedTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      removedTasks = prefs.getStringList('removed_tasks_hh') ?? [];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2f2a3e),
      appBar: AppBar(
        title: const Text('Missed tasks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff2f2a3e),
        iconTheme: const IconThemeData(color: Colors.white),

        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
                onPressed: (){
                  _showInfoDialog(context);
                },
                icon: const Icon(Icons.info_outline)),
          )
        ],
      ),

      body: ListView.builder(
        itemCount: removedTasks.length,
        itemBuilder: (context, index) {
          // Adding 1 to make the index 1-indexed
          int displayIndex = index + 1;

          return ListTile(
              title: Card(
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Card(
                        color: Colors.white,
                        child: SizedBox(
                          height: 25, // Set your desired height
                          width: 25,  // Set your desired width
                          child: Center(
                            child: Text(
                              '$displayIndex',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), // Add some space between the index and text
                      Expanded(
                        child: Text(
                          removedTasks[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )

          );
        },
      ),

    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Household chores'),
          content: const Text('1. All the tasks that you did not complete are stored here.\n'
              '2. Make sure to add them again and do it on time.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
