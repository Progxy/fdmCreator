import 'package:connectivity/connectivity.dart';
import 'package:fdmCreator/screens/mainDrawer.dart';
import 'package:fdmCreator/screens/utilizzo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'badConnection.dart';
import 'feedback.dart';

class CreateContent extends StatefulWidget {
  static const String routeName = "/createContent";

  @override
  _CreateContentState createState() => _CreateContentState();
}

class _CreateContentState extends State<CreateContent> {
  final List<String> choices = <String>[
    "FeedBack",
    "Aiuto",
  ];

  void choiceAction(String choice) async {
    if (choice == "Aiuto") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Utilizzo()));
    } else {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BadConnection()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedBack()));
      }
    }
  }

  double _width = 0;
  bool show = false;
  double _left = 0;
  int _duration = 1000;
  final List<String> draggableElements = [
    "Testo",
    "Immagine",
    "Video",
    "Link",
    "Spaziatura"
  ];
  final Map images = {
    "Testo": "Fast_text.png",
    "Immagine": "image.png",
    "Video": "video.png",
    "Link": "linker.png",
    "Spaziatura": "spacer.png"
  };
  String article = "";

  setElements() {
    setState(() {
      _duration = 600;
      _width = 0;
      show = false;
      _left = MediaQuery.of(context).size.width - 65;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setElements());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 192, 192, 192),
        ),
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "Area Creazione Contenuti",
            style: TextStyle(
              color: Color.fromARGB(255, 192, 192, 192),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              }).toList();
            },
          )
        ],
        backgroundColor: Color.fromARGB(255, 24, 37, 102),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: (MediaQuery.of(context).size.width * 75) / 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(),
                ),
              ),
              AnimatedPositioned(
                top: (MediaQuery.of(context).size.height * 35) / 100,
                left: _left,
                duration: Duration(milliseconds: _duration),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (!show) {
                        _duration = 300;
                        _width = (MediaQuery.of(context).size.width * 45) / 100;
                        show = true;
                        _left =
                            (MediaQuery.of(context).size.width - 65) - _width;
                      } else {
                        _duration = 600;
                        _width = 0;
                        show = false;
                        _left = MediaQuery.of(context).size.width - 65;
                      }
                    });
                  },
                  child: Icon(
                    show ? Icons.arrow_forward : Icons.arrow_back,
                    size: 35,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 24, 37, 102),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: AnimatedContainer(
                  width: _width,
                  height: MediaQuery.of(context).size.height - 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  duration: Duration(milliseconds: 1700),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: SingleChildScrollView(
                    child: Column(
                      children: draggableElements
                          .map((val) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Draggable(
                                  child: Image(
                                      image: AssetImage(
                                          "assets/images/" + images[val]),
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter),
                                  feedback: Column(
                                    children: [
                                      Image(
                                          image: AssetImage(
                                              "assets/images/" + images[val]),
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.topCenter),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        val,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                  childWhenDragging: Image(
                                      image: AssetImage(
                                          "assets/images/" + images[val]),
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter),
                                  onDragStarted: () {
                                    setState(() {
                                      _duration = 600;
                                      _width = 0;
                                      show = false;
                                      _left =
                                          MediaQuery.of(context).size.width -
                                              65;
                                    });
                                  },
                                  onDragEnd: (_) {
                                    setState(() {
                                      _duration = 300;
                                      _width =
                                          (MediaQuery.of(context).size.width *
                                                  45) /
                                              100;
                                      show = true;
                                      _left =
                                          (MediaQuery.of(context).size.width -
                                                  65) -
                                              _width;
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
