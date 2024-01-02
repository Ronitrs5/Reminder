import 'package:flutter/material.dart';
import 'package:reminder/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String name = '';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _imageAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<Offset> _textAnimation2;
  late Animation<Offset> _inputButtonAnimation;

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _imageAnimation = Tween<Offset>(
      begin: const Offset(0.0, -5.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(-5.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _textAnimation2 = Tween<Offset>(
      begin: const Offset(5.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _inputButtonAnimation = Tween<Offset>(
      begin: const Offset(0.0, 5.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2f2a3e),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _imageAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) => RadialGradient(
                      center: Alignment.center,
                      radius: 0.5, // Adjust the radius based on your preference
                      stops: [0.1, 0.3, 0.5, 1.0], // Adjust stops based on your preference
                      colors: [
                        Colors.white,
                        Colors.white24,
                        Colors.white10,
                        Colors.black45,

                      ],
                    ).createShader(bounds),
                    child: Image.asset(
                      "assets/icon_ticks.png",
                      color: Colors.white,
                      height: 80,
                    ),
                  )


                ],
              ),
            ),

            SlideTransition(
              position: _textAnimation,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "Reminder",
                  style: TextStyle(
                    // color: Color(0xff0f0d15),
                    color: Colors.white,
                    fontSize: 50,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
            ),

            SlideTransition(
              position: _textAnimation2,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Text(
                  "A place to track your dedication",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'NamunGothic',

                  ),
                ),
              ),
            ),

            SlideTransition(
              position: _inputButtonAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xff6f658e),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            SlideTransition(
              position: _inputButtonAnimation,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      String nameEntered = nameController.text.trim();

                      if(nameEntered.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kindly enter your name'), duration: Duration(seconds: 1),));                      }

                      else {

                        _saveData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color(0xff18161c),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', nameController.text);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
