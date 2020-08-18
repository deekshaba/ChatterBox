import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_buttons.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// to provide animation to single object
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  // Flutter animations
  //1. Build an animation controller
  AnimationController controller;
  // to create a curve we need to create animation
  Animation animation;

  // The init state is called when the welcome_screen state is just created
  @override
  void initState() {

    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
//    animation = ColorTween(begin: Colors.white, end: Colors.black)
//        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



//    controller.forward();
//    // to have upperbound always the upper bound should be between 0 and 1
//    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
//
//
//
//    //animation = ColorTween(begin: Colors.white, end: Color(0xff252326)).animate(controller);
//
////    animation.addStatusListener((status) {
////      if(status == AnimationStatus.completed){
////        controller.reverse(from: 1.0);
////      }else if(status == AnimationStatus.dismissed){
////        controller.forward();
////      }
////    });
//    controller.addListener(() {
//      setState(() {
//
//      });
//
//    });
//  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xff252326),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                //to create an animation and this is starting point
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['CHATTERBOX'],
                  textStyle: TextStyle(
                    fontSize: 37.0,
                    fontWeight: FontWeight.bold,


                  ),

                  speed: Duration(milliseconds: 700),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log In',color: Colors.lightBlueAccent,
              onpressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },),
            RoundedButton(title: 'Register',color: Colors.blueAccent,
              onpressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },)
          ],
        ),
      ),
    );
  }
}
