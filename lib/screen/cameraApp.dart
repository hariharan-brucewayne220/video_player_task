import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:videoplayer/components/rounded_button.dart';
import 'package:videoplayer/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:videoplayer/screen/Chewie.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
List<CameraDescription> cameras;


class CameraApp extends StatefulWidget {
  static const String id='camera_app';
  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  CameraController controller;
  @override
  void  initState()  {
    super.initState();
    get();
    controller = CameraController(cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  Future<void> get() async {
    cameras = await availableCameras();

  }
  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return RotationTransition(
      turns: AlwaysStoppedAnimation(270 / 360),
      child: CameraPreview(controller),
    );
  }
}

