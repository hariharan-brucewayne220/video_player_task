import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';
import 'package:videoplayer/screen/cameraApp.dart';
import 'package:videoplayer/screen/registration_screen.dart';
import 'package:videoplayer/screen/login_screen.dart';
import 'package:videoplayer/screen/welcome_screen.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/screen/Chewie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:videoplayer/screen/cameraApp.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(VideoPlayer());
}

class VideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes:{
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        ChewieDemo.id:(context)=>ChewieDemo(),
        CameraWidget.id:(context)=>CameraWidget(),

      },
    );
  }
}


