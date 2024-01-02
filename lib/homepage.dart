import 'package:flutter/material.dart';
import 'package:reminder/fragments/oneday.dart';
import 'package:reminder/fragments/sevenday.dart';
import 'package:reminder/fragments/threeday.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff554e6b),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: DefaultTabController(
          length: 2, // Number of tabs
          child: Column(
            children: [
              // TabBar
              TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: 'Study and Work',),
                  Tab(text: 'Household Chores'),
                  // Tab(text: 'Profile'),
                ],
                indicatorColor: Colors.white,


              ),
              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    OneDay(),
                    ThreeDay(),
                    // SevenDay(),
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
