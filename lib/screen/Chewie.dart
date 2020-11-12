import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:videoplayer/screen/cameraApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videoplayer/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:draggable_widget/draggable_widget.dart';
final _firestore=Firestore.instance;
FirebaseUser loggedInUser;
class ChewieDemo extends StatefulWidget {
  static const String id='chat_screen';
  ChewieDemo({this.title = 'Video player'});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  double volume = 80;
  final _auth=FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _videoPlayerController1 = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/480/big_buck_bunny_480p_20mb.mp4');
    _videoPlayerController2 = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/480/big_buck_bunny_480p_20mb.mp4');
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: 3 / 2,
        autoPlay: true,
        looping: true,
        routePageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, provider) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return VideoScaffold(
                child: Scaffold(
                  resizeToAvoidBottomPadding: false,
                  body: Container(
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: provider,
                  ),
                ),
              );
            },
          );
        }
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.light().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                _chewieController.enterFullScreen();
              },
              child: Text('Fullscreen'),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _chewieController.dispose();
                        _videoPlayerController2.pause();
                        _videoPlayerController2.seekTo(Duration(seconds: 0));
                        _chewieController = ChewieController(
                          videoPlayerController: _videoPlayerController1,
                          aspectRatio: 3 / 2,
                          autoPlay: true,
                          looping: true,
                        );
                      });
                    },
                    child: Padding(
                      child: Text("video-1"),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _chewieController.dispose();
                        _videoPlayerController1.pause();
                        _videoPlayerController1.seekTo(Duration(seconds: 0));
                        Navigator.pushNamed(context, CameraApp.id);
                      }



                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Cam"),
                    ),
                  ),
                )
              ],
            ),
            Row(
                crossAxisAlignment:  CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Volume Level'),
                  Slider(
                    min: 0,
                    max: 100,
                    value: volume,
                    onChanged: (value){
                      setState(() {
                        volume = value;
                      });

                      _videoPlayerController1.setVolume((volume).toDouble());
                    },
                  ),
                ]
            )
          ],
        ),
      ),
    );
  }
}

class VideoScaffold extends StatefulWidget {
  const VideoScaffold({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _VideoScaffoldState();
}

class _VideoScaffoldState extends State<VideoScaffold> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    AutoOrientation.landscapeAutoMode();
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    AutoOrientation.portraitAutoMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

