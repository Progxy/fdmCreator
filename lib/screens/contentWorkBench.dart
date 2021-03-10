import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
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

  AudioCache _audioController = AudioCache();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _leftController = TextEditingController();
  final _rightController = TextEditingController();
  final _bottomController = TextEditingController();
  final _topController = TextEditingController();
  final _sizeController = TextEditingController();
  double _widthEvidence = 0;
  double _heightEvidence = 0;
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
    "Video": "youtubeVideo.png",
    "Link": "linker.png",
    "Spaziatura": "spacer.png"
  };
  List<Widget> articleContainer = [];
  List<Widget> container = [];
  Map widgetInfo = {};
  List<Map> widgetsInfos = [];
  Map lista = {
    1: FontWeight.w300,
    2: FontWeight.normal,
    3: FontWeight.w600,
    4: FontWeight.bold,
    5: FontWeight.w800
  };
  List<int> elementi = [1, 2, 3, 4, 5];
  String dropdownValue = 1.toString();
  var fontWeight = FontWeight.w300;
  int index = 0;
  Random random = new Random();
  Map keysValue = {};

  selectedWidget(key) {
    int ind = keysValue[key];
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Elimina Widget",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: Text(
                  "Sicuro di eliminare questo widget ?",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "ANNULLA",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ),
                  CupertinoDialogAction(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        widgetInfo.clear();
                        widgetsInfos.removeAt(ind);
                        container.removeAt(ind);
                        articleContainer.removeAt(ind);
                        keysValue.remove(key);
                        keysValue.forEach((key, value) => {
                              if (value > ind) {keysValue[key] = value - 1}
                            });
                        index--;
                      });
                      _audioController.play("assets/sounds/deleteEffect.mp4");
                    },
                    child: Text(
                      "ELIMINA",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "Elimina Widget",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: Text(
                  "Sicuro di eliminare questo widget ?",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "ANNULLA",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        _audioController.play("sounds/deleteEffect.mp4");
                        widgetInfo.clear();
                        widgetsInfos.removeAt(ind);
                        container.removeAt(ind);
                        articleContainer.removeAt(ind);
                        keysValue.remove(key);
                        keysValue.forEach((key, value) => {
                              if (value > ind) {keysValue[key] = value - 1}
                            });
                        index--;
                      });
                    },
                    child: Text(
                      "ELIMINA",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }
    refreshWorkBench();
    return;
  }

  addText() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Aggiungi Testo",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _textController,
                          maxLines: 20,
                          decoration: const InputDecoration(
                            hintText: "Inserire il testo",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Testo",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Text": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _sizeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la grandezza del testo",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Grandezza Testo",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Size": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Scegliere l'intesità dei caratteri",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 40,
                          elevation: 20,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              fontWeight = lista[int.parse(dropdownValue)];
                            });
                          },
                          items: elementi
                              .map((value) => new DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value.toString()),
                                  ))
                              .toList(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _topController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la spaziatura Superiore",
                            hintStyle: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Spaziatura Superiore",
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Top": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _bottomController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la spaziatura inferiore",
                            hintStyle: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Spaziatura Inferiore",
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Bottom": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _rightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la spaziatura destra",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Spaziatura Destra",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Right": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _leftController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la spaziatura sinistra",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Spaziatura Sinistra",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Left": value});
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "CONFERMA",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        setState(() {
                          widgetInfo.addAll({"FontWeight": fontWeight});
                          Key chiavetta =
                              Key(random.nextInt(100000000).toString());
                          keysValue.addAll({chiavetta: index});
                          container.add(
                            GestureDetector(
                              key: chiavetta,
                              onLongPress: () => selectedWidget(chiavetta),
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: double.parse(widgetInfo["Top"]),
                                    bottom: double.parse(widgetInfo["Bottom"]),
                                    left: double.parse(widgetInfo["Left"]),
                                    right: double.parse(widgetInfo["Right"]),
                                  ),
                                  child: Text(
                                    widgetInfo["Text"],
                                    style: TextStyle(
                                      fontSize:
                                          double.parse(widgetInfo["Size"]),
                                      fontWeight: widgetInfo["FontWeight"],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                          articleContainer.add(
                            Padding(
                              padding: EdgeInsets.only(
                                top: double.parse(widgetInfo["Top"]),
                                bottom: double.parse(widgetInfo["Bottom"]),
                                left: double.parse(widgetInfo["Left"]),
                                right: double.parse(widgetInfo["Right"]),
                              ),
                              child: Text(
                                widgetInfo["Text"],
                                style: TextStyle(
                                  fontSize: double.parse(widgetInfo["Size"]),
                                  fontWeight: widgetInfo["FontWeight"],
                                ),
                              ),
                            ),
                          );
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          dropdownValue = 1.toString();
                          fontWeight = FontWeight.w300;
                          _textController.clear();
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                          _sizeController.clear();
                        });
                        _audioController.play("assets/sounds/addedElement.mp4");
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "ANNULLA",
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        widgetInfo.clear();
                        dropdownValue = 1.toString();
                        fontWeight = FontWeight.w300;
                        _textController.clear();
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                        _sizeController.clear();
                      });
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "Aggiungi Testo",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _textController,
                          maxLines: 20,
                          decoration: const InputDecoration(
                            hintText: "Inserire il testo",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Testo",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Text": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _sizeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la grandezza del testo",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Grandezza Testo",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Size": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Scegliere l'intesità dei caratteri",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 40,
                          elevation: 20,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              fontWeight = lista[int.parse(dropdownValue)];
                            });
                          },
                          items: elementi
                              .map((value) => new DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value.toString()),
                                  ))
                              .toList(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _topController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la spaziatura Superiore",
                            hintStyle: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Spaziatura Superiore",
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Top": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _bottomController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la spaziatura inferiore",
                            hintStyle: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Spaziatura Inferiore",
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Bottom": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _rightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la spaziatura destra",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Spaziatura Destra",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Right": value});
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _leftController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Inserire la spaziatura sinistra",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Spaziatura Sinistra",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            }
                            widgetInfo.addAll({"Left": value});
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      "CONFERMA",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        _audioController.play("sounds/addedElement.mp4");
                        setState(() {
                          widgetInfo.addAll({"FontWeight": fontWeight});
                          Key chiavetta =
                              Key(random.nextInt(100000000).toString());
                          keysValue.addAll({chiavetta: index});
                          container.add(
                            GestureDetector(
                              key: chiavetta,
                              onLongPress: () => selectedWidget(chiavetta),
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: double.parse(widgetInfo["Top"]),
                                    bottom: double.parse(widgetInfo["Bottom"]),
                                    left: double.parse(widgetInfo["Left"]),
                                    right: double.parse(widgetInfo["Right"]),
                                  ),
                                  child: Text(
                                    widgetInfo["Text"],
                                    style: TextStyle(
                                      fontSize:
                                          double.parse(widgetInfo["Size"]),
                                      fontWeight: widgetInfo["FontWeight"],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                          articleContainer.add(
                            Padding(
                              padding: EdgeInsets.only(
                                top: double.parse(widgetInfo["Top"]),
                                bottom: double.parse(widgetInfo["Bottom"]),
                                left: double.parse(widgetInfo["Left"]),
                                right: double.parse(widgetInfo["Right"]),
                              ),
                              child: Text(
                                widgetInfo["Text"],
                                style: TextStyle(
                                  fontSize: double.parse(widgetInfo["Size"]),
                                  fontWeight: widgetInfo["FontWeight"],
                                ),
                              ),
                            ),
                          );
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          dropdownValue = 1.toString();
                          fontWeight = FontWeight.w300;
                          _textController.clear();
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                          _sizeController.clear();
                        });
                      }
                    },
                  ),
                  TextButton(
                    child: Text(
                      "ANNULLA",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      setState(() {
                        widgetInfo.clear();
                        dropdownValue = 1.toString();
                        fontWeight = FontWeight.w300;
                        _textController.clear();
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                        _sizeController.clear();
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
    refreshWorkBench();
    return;
  }

  void addImage() {
    print("Implement addImage");
  }

  void addVideo() {
    print("Implement addVideo");
  }

  void addLink() {
    print("Implement addLink");
  }

  void addPadding() {
    print("Implement addPadding");
  }

  refreshWorkBench() {
    setState(() {
      print("Refresh");
    });
  }

  cleanWorkBench() {
    setState(() {
      container.clear();
      articleContainer.clear();
    });
  }

  void saveWorkBench() {
    print("this function will also need title, date and type of article!");
  }

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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: container,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DragTarget(
                          builder: (BuildContext context, List<String> incoming,
                              List rejected) {
                            return AnimatedContainer(
                              height: _heightEvidence,
                              width: _widthEvidence,
                              curve: Curves.fastLinearToSlowEaseIn,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(100, 135, 206, 250),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 3,
                                ),
                              ),
                              duration: Duration(milliseconds: 300),
                            );
                          },
                          onAccept: (data) {
                            switch (data) {
                              case "Testo":
                                addText();
                                break;
                              case "Immagine":
                                addImage();
                                break;
                              case "Video":
                                addVideo();
                                break;
                              case "Link":
                                addLink();
                                break;
                              case "Spaziatura":
                                addPadding();
                                break;
                            }
                            setState(() {
                              _duration = 600;
                              _width = 0;
                              show = false;
                              _left = MediaQuery.of(context).size.width - 65;
                              _heightEvidence = 0;
                              _widthEvidence = 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
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
                top: 15,
                child: AnimatedContainer(
                  width: _width,
                  height: MediaQuery.of(context).size.height - 115,
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
                                  data: val,
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
                                      _heightEvidence = 150;
                                      _widthEvidence =
                                          ((MediaQuery.of(context).size.width *
                                                      75) /
                                                  100) -
                                              50;
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
                                      _heightEvidence = 0;
                                      _widthEvidence = 0;
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
