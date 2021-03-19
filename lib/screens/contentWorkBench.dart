import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fdmCreator/firebaseProjectsManager.dart';
import 'package:fdmCreator/screens/mainDrawer.dart';
import 'package:fdmCreator/screens/utilizzo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import '../accountInfo.dart';
import 'badConnection.dart';
import 'feedback.dart';

class CreateContent extends StatefulWidget {
  static const String routeName = "/createContent";
  final bool isManager = AccountInfo.isManager;
  final FirebaseDatabase database =
      FirebaseDatabase(app: FirebaseProjectsManager().getSecondary());

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
  final _linkController = TextEditingController();
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  var colorEvidence = Colors.white;
  var containerColorEvidence = Colors.white;
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
  Map articleContainer = {};
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
  File _image;
  final picker = ImagePicker();
  String descriptionButtonCamera = "Scatta Foto";
  String descriptionButtonGallery = "Scegli Foto Galleria";
  String descriptionVideoCamera = "Registra Video";
  String descriptionVideoGallery = "Scegli Video Galleria";
  String title = "";
  String date = "";
  Map imagesStorage = {};
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  VideoPlayerController _videoController;
  VideoPlayerController _videoControllerSecondary;
  Map videoControllersInUse = {};
  List<String> elementiArticoli = [
    "Foto",
    "Video",
    "Articolo",
    "Evento",
    "Ci Hanno Scritto",
    "Stampa"
  ];
  String typeArticle = "Foto";
  DateTime _dateTime;
  List<String> imagesChoosen = [];
  var imageChoosenDropDown = "";
  var posterImage;
  Widget containerImage = Image.network(
    "statrt.com",
    fit: BoxFit.fitWidth,
    alignment: Alignment.topCenter,
    height: 200,
    width: 200,
    errorBuilder:
        (BuildContext context, Object exception, StackTrace stackTrace) {
      return Image.asset(
        "assets/images/error_image.png",
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
        width: 200,
        height: 200,
      );
    },
  );
  bool isALink = false;
  List linkStorage = [];

  //TODO : modifica sicurezza per evitare errori, soprattutto che il link dei video non sia youtube ! E anche la validità dei link inseriti !

  void verifyLink() {
    print("Implement verify Link ");
  }

  managerVideoController() {
    setState(() {
      _videoController.value.isPlaying
          ? _videoController.pause()
          : _videoController.play();
    });
    refreshWorkBench();
  }

  managerVideocontrollerSecondary() {
    setState(() {
      _videoControllerSecondary.value.isPlaying
          ? _videoControllerSecondary.pause()
          : _videoControllerSecondary.play();
    });
    refreshWorkBench();
  }

  addMediaToStorage(File imagePath) async {
    Random randomId = new Random();
    final id = randomId.nextInt(999999999).toString();
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(title + "/" + id)
          .putFile(imagePath);
      final String resultLink = await getImageLink(id);
      return resultLink;
    } on FirebaseException catch (e) {
      print("Error while uploading image : $e");
      return "error.com";
    }
  }

  getImageLink(String image) async {
    try {
      String link = await firebase_storage.FirebaseStorage.instance
          .ref(title + "/" + image)
          .getDownloadURL();
      return link;
    } catch (e) {
      print("Error while getting image's link : $e");
      return "error.com";
    }
  }

  getVideoFromCamera() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);
    bool isSelected = false;
    refreshWorkBench();
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widgetInfo["VideoPath"] = _image;
        isSelected = true;
      } else {
        widgetInfo["VideoPath"] = null;
        isSelected = false;
      }
    });
    return isSelected;
  }

  getVideoFromGallery() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    bool isSelected = false;
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widgetInfo["VideoPath"] = _image;
        isSelected = true;
      } else {
        widgetInfo["VideoPath"] = null;
        isSelected = false;
      }
    });
    return isSelected;
  }

  getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    bool isSelected = false;
    refreshWorkBench();
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widgetInfo["ImagePath"] = _image;
        isSelected = true;
      } else {
        widgetInfo["ImagePath"] = null;
        isSelected = false;
      }
    });
    return isSelected;
  }

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    bool isSelected = false;
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widgetInfo["ImagePath"] = _image;
        isSelected = true;
      } else {
        widgetInfo["ImagePath"] = null;
        isSelected = false;
      }
    });
    return isSelected;
  }

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
                        _audioController.play("sounds/deleteEffect.mp4");
                        final articleIndex =
                            articleContainer.keys.toList()[ind];
                        widgetInfo.clear();
                        widgetsInfos.removeAt(ind);
                        container.removeAt(ind);
                        articleContainer.remove(articleIndex);
                        keysValue.remove(key);
                        keysValue.forEach((key, value) => {
                              if (value > ind) {keysValue[key] = value - 1}
                            });
                        index--;
                        if (videoControllersInUse.containsKey(key)) {
                          final val = videoControllersInUse[key];
                          if (val == _videoController) {
                            _videoController = null;
                          } else if (val == _videoControllerSecondary) {
                            _videoControllerSecondary = null;
                          }
                          videoControllersInUse.remove(key);
                        }
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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
                        _audioController.play("sounds/deleteEffect.mp4");
                        final articleIndex =
                            articleContainer.keys.toList()[ind];
                        widgetInfo.clear();
                        widgetsInfos.removeAt(ind);
                        container.removeAt(ind);
                        articleContainer.remove(articleIndex);
                        keysValue.remove(key);
                        keysValue.forEach((key, value) => {
                              if (value > ind) {keysValue[key] = value - 1}
                            });
                        index--;
                        if (videoControllersInUse.containsKey(key)) {
                          final val = videoControllersInUse[key];
                          if (val == _videoController) {
                            _videoController = null;
                          } else if (val == _videoControllerSecondary) {
                            _videoControllerSecondary = null;
                          }
                          videoControllersInUse.remove(key);
                        }
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
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
                          articleContainer.addAll({
                            chiavetta: Padding(
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
                          });
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
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
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
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      });
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
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
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
                          articleContainer.addAll({
                            chiavetta: Padding(
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
                          });
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
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
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
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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

  addImage() {
    setState(() {
      widgetInfo.addAll({"ImageLink": null});
      widgetInfo.addAll({"ImagePath": null});
    });
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              widgetInfo.addAll({"ImageLink": ""});
              widgetInfo.addAll({"ImagePath": ""});
              return CupertinoAlertDialog(
                title: Text(
                  "Aggiungi Immagine",
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
                          controller: _linkController,
                          maxLines: 20,
                          decoration: const InputDecoration(
                            hintText: "Inserire il link",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Link",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty && (_image == null)) {
                              return "Dati Mancanti";
                            } else if (value.isNotEmpty) {
                              widgetInfo["ImageLink"] = value;
                              widgetInfo["ImagePath"] = null;
                            } else {
                              widgetInfo["ImageLink"] = null;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: getImageFromCamera,
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionButtonCamera,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: getImageFromGallery,
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionButtonGallery,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
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
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
                          Key chiavetta =
                              Key(random.nextInt(100000000).toString());
                          keysValue.addAll({chiavetta: index});
                          if (widgetInfo["ImagePath"] != null) {
                            imagesStorage
                                .addAll({chiavetta: widgetInfo["ImagePath"]});
                            final Map elem = {};
                            elem.addAll({"Top": widgetInfo["Top"]});
                            elem.addAll({"Bottom": widgetInfo["Bottom"]});
                            elem.addAll({"Left": widgetInfo["Left"]});
                            elem.addAll({"Right": widgetInfo["Right"]});
                            elem.addAll({"isVideo": false});
                            articleContainer.addAll({chiavetta: elem});
                          } else {
                            articleContainer.addAll({
                              chiavetta: Padding(
                                padding: EdgeInsets.only(
                                  top: double.parse(widgetInfo["Top"]),
                                  bottom: double.parse(widgetInfo["Bottom"]),
                                  left: double.parse(widgetInfo["Left"]),
                                  right: double.parse(widgetInfo["Right"]),
                                ),
                                child: Image.network(
                                  widgetInfo["ImageLink"],
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  height: 200,
                                  width: 200,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Image.asset(
                                      "assets/images/error_image.png",
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                      width: 200,
                                      height: 200,
                                    );
                                  },
                                ),
                              ),
                            });
                          }
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
                                  child: widgetInfo["ImagePath"] == null
                                      ? Image.network(
                                          widgetInfo["ImageLink"],
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.topCenter,
                                          height: 200,
                                          width: 200,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                            return Image.asset(
                                              "assets/images/error_image.png",
                                              fit: BoxFit.fitWidth,
                                              alignment: Alignment.topCenter,
                                              width: 200,
                                              height: 200,
                                            );
                                          },
                                        )
                                      : Image.file(
                                          widgetInfo["ImagePath"],
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.topCenter,
                                          width: 200,
                                          height: 200,
                                        ),
                                ),
                              ),
                            ),
                          );
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          _linkController.clear();
                          descriptionButtonGallery = "Scegli Foto Galleria";
                          descriptionButtonCamera = "Scatta Foto";
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                          _sizeController.clear();
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
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
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                        _linkController.clear();
                        _image = null;
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      });
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
                  "Aggiungi Immagine",
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
                          controller: _linkController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Inserire il link",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Link",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (value) {
                            final result = value.isNotEmpty;
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                descriptionButtonCamera = "Scegli Foto";
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                              }
                            });
                            refreshWorkBench();
                          },
                          validator: (value) {
                            final imagePath = widgetInfo["ImagePath"];
                            if (value.isEmpty && (imagePath == null)) {
                              return "Dati Mancanti";
                            } else if (value.isNotEmpty) {
                              widgetInfo["ImageLink"] = value;
                              widgetInfo["ImagePath"] = null;
                            } else {
                              widgetInfo["ImageLink"] = null;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getImageFromCamera();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionButtonCamera = "Foto Selezionata";
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                              } else {
                                descriptionButtonCamera = "Scatta Foto";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionButtonCamera,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getImageFromGallery();
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionButtonGallery = "Foto Selezionata";
                                descriptionButtonCamera = "Scatta Foto";
                              } else {
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionButtonGallery,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
                          Key chiavetta =
                              Key(random.nextInt(100000000).toString());
                          keysValue.addAll({chiavetta: index});
                          if (widgetInfo["ImagePath"] != null) {
                            imagesStorage
                                .addAll({chiavetta: widgetInfo["ImagePath"]});
                            final Map elem = {};
                            elem.addAll({"Top": widgetInfo["Top"]});
                            elem.addAll({"Bottom": widgetInfo["Bottom"]});
                            elem.addAll({"Left": widgetInfo["Left"]});
                            elem.addAll({"Right": widgetInfo["Right"]});
                            elem.addAll({"isVideo": false});
                            articleContainer.addAll({chiavetta: elem});
                          } else {
                            articleContainer.addAll({
                              chiavetta: Padding(
                                padding: EdgeInsets.only(
                                  top: double.parse(widgetInfo["Top"]),
                                  bottom: double.parse(widgetInfo["Bottom"]),
                                  left: double.parse(widgetInfo["Left"]),
                                  right: double.parse(widgetInfo["Right"]),
                                ),
                                child: Image.network(
                                  widgetInfo["ImageLink"],
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  height: 200,
                                  width: 200,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Image.asset(
                                      "assets/images/error_image.png",
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                      width: 200,
                                      height: 200,
                                    );
                                  },
                                ),
                              ),
                            });
                          }
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
                                  child: widgetInfo["ImagePath"] == null
                                      ? Image.network(
                                          widgetInfo["ImageLink"],
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.topCenter,
                                          height: 200,
                                          width: 200,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                            return Image.asset(
                                              "assets/images/error_image.png",
                                              fit: BoxFit.fitWidth,
                                              alignment: Alignment.topCenter,
                                              width: 200,
                                              height: 200,
                                            );
                                          },
                                        )
                                      : Image.file(
                                          widgetInfo["ImagePath"],
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.topCenter,
                                          width: 200,
                                          height: 200,
                                        ),
                                ),
                              ),
                            ),
                          );
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          _linkController.clear();
                          descriptionButtonGallery = "Scegli Foto Galleria";
                          descriptionButtonCamera = "Scatta Foto";
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                          _sizeController.clear();
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
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
                      setState(() {
                        widgetInfo.clear();
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                        _linkController.clear();
                        descriptionButtonGallery = "Scegli Foto Galleria";
                        descriptionButtonCamera = "Scatta Foto";
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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

  addVideo() {
    if ((_videoController != null) && (_videoControllerSecondary != null)) {
      if (Platform.isIOS) {
        showCupertinoDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                "Errore",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              content: Text(
                "Troppi video in uso, eliminarne uno!",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Errore",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              content: Text(
                "Troppi video in uso, eliminarne uno!",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                ),
              ],
            );
          },
        );
      }
      return;
    }
    setState(() {
      widgetInfo.addAll({"VideoLink": null});
      widgetInfo.addAll({"VideoPath": null});
    });
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Aggiungi Video",
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
                          controller: _linkController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Inserire il link",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Link",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (value) {
                            final result = value.isNotEmpty;
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                descriptionVideoCamera = "Registra Video";
                                descriptionVideoGallery =
                                    "Scegli Video Galleria";
                              }
                            });
                            refreshWorkBench();
                          },
                          validator: (value) {
                            final imagePath = widgetInfo["VideoPath"];
                            if (value.isEmpty && (imagePath == null)) {
                              return "Dati Mancanti";
                            } else if (value.isNotEmpty) {
                              widgetInfo["VideoLink"] = value;
                              widgetInfo["VideoPath"] = null;
                            } else {
                              widgetInfo["VideoLink"] = null;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getVideoFromCamera();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionVideoCamera = "Video Selezionato";
                                descriptionVideoGallery =
                                    "Scegli Video Galleria";
                              } else {
                                descriptionVideoCamera = "Registra Video";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionVideoCamera,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getVideoFromGallery();
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionVideoCamera = "Registra Video";
                                descriptionVideoGallery = "Video Selezionato";
                              } else {
                                descriptionVideoGallery =
                                    "Scegli Video Galleria";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionVideoGallery,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        bool isSecondary;
                        Key chiavetta =
                            Key(random.nextInt(100000000).toString());
                        if (_videoController == null) {
                          if (widgetInfo["VideoPath"] != null) {
                            _videoController = VideoPlayerController.file(
                                widgetInfo["VideoPath"]);
                            await _videoController.initialize();
                            await _videoController.setLooping(true);
                            videoControllersInUse
                                .addAll({chiavetta: _videoController});
                          } else {
                            _videoController = VideoPlayerController.network(
                                widgetInfo["VideoLink"]);
                            await _videoController.initialize();
                            await _videoController.setLooping(true);

                            videoControllersInUse
                                .addAll({chiavetta: _videoController});
                          }
                          isSecondary = false;
                        } else {
                          if (widgetInfo["VideoPath"] != null) {
                            _videoControllerSecondary =
                                VideoPlayerController.file(
                                    widgetInfo["VideoPath"]);
                            await _videoControllerSecondary.initialize();
                            await _videoController.setLooping(true);
                            videoControllersInUse
                                .addAll({chiavetta: _videoControllerSecondary});
                          } else {
                            _videoControllerSecondary =
                                VideoPlayerController.network(
                                    widgetInfo["VideoLink"]);
                            await _videoControllerSecondary.initialize();
                            await _videoController.setLooping(true);
                            videoControllersInUse
                                .addAll({chiavetta: _videoControllerSecondary});
                          }
                          isSecondary = true;
                        }
                        container.add(
                          Column(
                            children: [
                              GestureDetector(
                                key: chiavetta,
                                onLongPress: () => selectedWidget(chiavetta),
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: double.parse(widgetInfo["Top"]),
                                      bottom:
                                          double.parse(widgetInfo["Bottom"]),
                                      left: double.parse(widgetInfo["Left"]),
                                      right: double.parse(widgetInfo["Right"]),
                                    ),
                                    child: GestureDetector(
                                      onTap: isSecondary
                                          ? () =>
                                              managerVideocontrollerSecondary()
                                          : () => managerVideoController(),
                                      child: Container(
                                        child: isSecondary
                                            ? _videoControllerSecondary
                                                    .value.initialized
                                                ? AspectRatio(
                                                    aspectRatio:
                                                        _videoControllerSecondary
                                                            .value.aspectRatio,
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: <Widget>[
                                                        VideoPlayer(
                                                            _videoControllerSecondary),
                                                        VideoProgressIndicator(
                                                          _videoControllerSecondary,
                                                          allowScrubbing: true,
                                                          colors:
                                                              VideoProgressColors(
                                                            playedColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    24,
                                                                    37,
                                                                    102),
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    color: Colors.black,
                                                    height: 200,
                                                    width: 200,
                                                  )
                                            : _videoController.value.initialized
                                                ? AspectRatio(
                                                    aspectRatio:
                                                        _videoController
                                                            .value.aspectRatio,
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: <Widget>[
                                                        VideoPlayer(
                                                            _videoController),
                                                        VideoProgressIndicator(
                                                          _videoController,
                                                          allowScrubbing: true,
                                                          colors:
                                                              VideoProgressColors(
                                                            playedColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    24,
                                                                    37,
                                                                    102),
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    color: Colors.black,
                                                    height: 200,
                                                    width: 200,
                                                  ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
                          keysValue.addAll({chiavetta: index});
                          if (widgetInfo["VideoPath"] != null) {
                            imagesStorage
                                .addAll({chiavetta: widgetInfo["VideoPath"]});
                            final Map elem = {};
                            elem.addAll({"Top": widgetInfo["Top"]});
                            elem.addAll({"Bottom": widgetInfo["Bottom"]});
                            elem.addAll({"Left": widgetInfo["Left"]});
                            elem.addAll({"Right": widgetInfo["Right"]});
                            elem.addAll({"isVideo": true});
                            elem.addAll({"isSecondary": isSecondary});
                            articleContainer.addAll({chiavetta: elem});
                          } else {
                            articleContainer.addAll({
                              chiavetta: Padding(
                                padding: EdgeInsets.only(
                                  top: double.parse(widgetInfo["Top"]),
                                  bottom: double.parse(widgetInfo["Bottom"]),
                                  left: double.parse(widgetInfo["Left"]),
                                  right: double.parse(widgetInfo["Right"]),
                                ),
                                child: GestureDetector(
                                  onTap: isSecondary
                                      ? () => managerVideocontrollerSecondary()
                                      : () => managerVideoController(),
                                  child: Container(
                                    child: isSecondary
                                        ? _videoControllerSecondary
                                                .value.initialized
                                            ? AspectRatio(
                                                aspectRatio:
                                                    _videoControllerSecondary
                                                        .value.aspectRatio,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: <Widget>[
                                                    VideoPlayer(
                                                        _videoControllerSecondary),
                                                    VideoProgressIndicator(
                                                      _videoControllerSecondary,
                                                      allowScrubbing: true,
                                                      colors:
                                                          VideoProgressColors(
                                                        playedColor: const Color
                                                                .fromARGB(
                                                            255, 24, 37, 102),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                color: Colors.black,
                                                height: 200,
                                                width: 200,
                                              )
                                        : _videoController.value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _videoController
                                                    .value.aspectRatio,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: <Widget>[
                                                    VideoPlayer(
                                                        _videoController),
                                                    VideoProgressIndicator(
                                                      _videoController,
                                                      allowScrubbing: true,
                                                      colors:
                                                          VideoProgressColors(
                                                        playedColor: const Color
                                                                .fromARGB(
                                                            255, 24, 37, 102),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                color: Colors.black,
                                                height: 200,
                                                width: 200,
                                              ),
                                  ),
                                ),
                              ),
                            });
                          }
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          _linkController.clear();
                          descriptionVideoGallery = "Scegli Video Galleria";
                          descriptionVideoCamera = "Registra Video";
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                          _sizeController.clear();
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "ANNULLA",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        widgetInfo.clear();
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                        _linkController.clear();
                        descriptionVideoCamera = "Registra Video";
                        descriptionVideoGallery = "Scegli Video Galleria";
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      });
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
                  "Aggiungi Video",
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
                          controller: _linkController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Inserire il link",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Link",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (value) {
                            final result = value.isNotEmpty;
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                descriptionVideoCamera = "Registra Video";
                                descriptionVideoGallery =
                                    "Scegli Video Galleria";
                              }
                            });
                            refreshWorkBench();
                          },
                          validator: (value) {
                            final imagePath = widgetInfo["VideoPath"];
                            if (value.isEmpty && (imagePath == null)) {
                              return "Dati Mancanti";
                            } else if (value.isNotEmpty) {
                              widgetInfo["VideoLink"] = value;
                              widgetInfo["VideoPath"] = null;
                            } else {
                              widgetInfo["VideoLink"] = null;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getVideoFromCamera();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionVideoCamera = "Video Selezionato";
                                descriptionVideoGallery =
                                    "Scegli Video Galleria";
                              } else {
                                descriptionVideoCamera = "Registra Video";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionVideoCamera,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getVideoFromGallery();
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionVideoCamera = "Registra Video";
                                descriptionVideoGallery = "Video Selezionato";
                              } else {
                                descriptionVideoGallery =
                                    "Scegli Video Galleria";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionVideoGallery,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        bool isSecondary;
                        Key chiavetta =
                            Key(random.nextInt(100000000).toString());
                        if (_videoController == null) {
                          if (widgetInfo["VideoPath"] != null) {
                            _videoController = VideoPlayerController.file(
                                widgetInfo["VideoPath"]);
                            await _videoController.initialize();
                            await _videoController.setLooping(true);
                            videoControllersInUse
                                .addAll({chiavetta: _videoController});
                          } else {
                            _videoController = VideoPlayerController.network(
                                widgetInfo["VideoLink"]);
                            await _videoController.initialize();
                            await _videoController.setLooping(true);
                            videoControllersInUse
                                .addAll({chiavetta: _videoController});
                          }
                          isSecondary = false;
                        } else {
                          if (widgetInfo["VideoPath"] != null) {
                            _videoControllerSecondary =
                                VideoPlayerController.file(
                                    widgetInfo["VideoPath"]);
                            await _videoControllerSecondary.initialize();
                            await _videoController.setLooping(true);
                            videoControllersInUse
                                .addAll({chiavetta: _videoControllerSecondary});
                          } else {
                            _videoControllerSecondary =
                                VideoPlayerController.network(
                                    widgetInfo["VideoLink"]);
                            await _videoControllerSecondary.initialize();
                            await _videoController.setLooping(true);
                            videoControllersInUse
                                .addAll({chiavetta: _videoControllerSecondary});
                          }
                          isSecondary = true;
                        }
                        container.add(
                          Column(
                            children: [
                              GestureDetector(
                                key: chiavetta,
                                onLongPress: () => selectedWidget(chiavetta),
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: double.parse(widgetInfo["Top"]),
                                      bottom:
                                          double.parse(widgetInfo["Bottom"]),
                                      left: double.parse(widgetInfo["Left"]),
                                      right: double.parse(widgetInfo["Right"]),
                                    ),
                                    child: GestureDetector(
                                      onTap: isSecondary
                                          ? () =>
                                              managerVideocontrollerSecondary()
                                          : () => managerVideoController(),
                                      child: Container(
                                        child: isSecondary
                                            ? _videoControllerSecondary
                                                    .value.initialized
                                                ? AspectRatio(
                                                    aspectRatio:
                                                        _videoControllerSecondary
                                                            .value.aspectRatio,
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: <Widget>[
                                                        VideoPlayer(
                                                            _videoControllerSecondary),
                                                        VideoProgressIndicator(
                                                          _videoControllerSecondary,
                                                          allowScrubbing: true,
                                                          colors:
                                                              VideoProgressColors(
                                                            playedColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    24,
                                                                    37,
                                                                    102),
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    color: Colors.black,
                                                    height: 200,
                                                    width: 200,
                                                  )
                                            : _videoController.value.initialized
                                                ? AspectRatio(
                                                    aspectRatio:
                                                        _videoController
                                                            .value.aspectRatio,
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: <Widget>[
                                                        VideoPlayer(
                                                            _videoController),
                                                        VideoProgressIndicator(
                                                          _videoController,
                                                          allowScrubbing: true,
                                                          colors:
                                                              VideoProgressColors(
                                                            playedColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    24,
                                                                    37,
                                                                    102),
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    color: Colors.black,
                                                    height: 200,
                                                    width: 200,
                                                  ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
                          keysValue.addAll({chiavetta: index});
                          if (widgetInfo["VideoPath"] != null) {
                            imagesStorage
                                .addAll({chiavetta: widgetInfo["VideoPath"]});
                            final Map elem = {};
                            elem.addAll({"Top": widgetInfo["Top"]});
                            elem.addAll({"Bottom": widgetInfo["Bottom"]});
                            elem.addAll({"Left": widgetInfo["Left"]});
                            elem.addAll({"Right": widgetInfo["Right"]});
                            elem.addAll({"isVideo": true});
                            elem.addAll({"isSecondary": isSecondary});
                            articleContainer.addAll({chiavetta: elem});
                          } else {
                            articleContainer.addAll({
                              chiavetta: Padding(
                                padding: EdgeInsets.only(
                                  top: double.parse(widgetInfo["Top"]),
                                  bottom: double.parse(widgetInfo["Bottom"]),
                                  left: double.parse(widgetInfo["Left"]),
                                  right: double.parse(widgetInfo["Right"]),
                                ),
                                child: GestureDetector(
                                  onTap: isSecondary
                                      ? () => managerVideocontrollerSecondary()
                                      : () => managerVideoController(),
                                  child: Container(
                                    child: isSecondary
                                        ? _videoControllerSecondary
                                                .value.initialized
                                            ? AspectRatio(
                                                aspectRatio:
                                                    _videoControllerSecondary
                                                        .value.aspectRatio,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: <Widget>[
                                                    VideoPlayer(
                                                        _videoControllerSecondary),
                                                    VideoProgressIndicator(
                                                      _videoControllerSecondary,
                                                      allowScrubbing: true,
                                                      colors:
                                                          VideoProgressColors(
                                                        playedColor: const Color
                                                                .fromARGB(
                                                            255, 24, 37, 102),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                color: Colors.black,
                                                height: 200,
                                                width: 200,
                                              )
                                        : _videoController.value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _videoController
                                                    .value.aspectRatio,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: <Widget>[
                                                    VideoPlayer(
                                                        _videoController),
                                                    VideoProgressIndicator(
                                                      _videoController,
                                                      allowScrubbing: true,
                                                      colors:
                                                          VideoProgressColors(
                                                        playedColor: const Color
                                                                .fromARGB(
                                                            255, 24, 37, 102),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                color: Colors.black,
                                                height: 200,
                                                width: 200,
                                              ),
                                  ),
                                ),
                              ),
                            });
                          }
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          _linkController.clear();
                          descriptionVideoGallery = "Scegli Video Galleria";
                          descriptionVideoCamera = "Registra Video";
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                          _sizeController.clear();
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
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
                      setState(() {
                        widgetInfo.clear();
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                        _linkController.clear();
                        descriptionVideoCamera = "Registra Video";
                        descriptionVideoGallery = "Scegli Video Galleria";
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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

  addLink() {
    setState(() {
      widgetInfo.addAll({"Text": null});
      widgetInfo.addAll({"Link": null});
    });
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Aggiungi Link",
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
                          controller: _linkController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Inserire il link",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Link",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            } else {
                              widgetInfo["Link"] = value;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _textController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Inserire il testo",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Testo (Opzionale)",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              widgetInfo["Text"] = null;
                            } else {
                              widgetInfo["Text"] = value;
                            }
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
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
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
                                  child: GestureDetector(
                                    onTap: () {
                                      launch(widgetInfo["Link"]);
                                    },
                                    child: Text(
                                      widgetInfo["Text"] == null
                                          ? widgetInfo["Link"]
                                          : widgetInfo["Text"],
                                      style: TextStyle(
                                        fontSize:
                                            double.parse(widgetInfo["Size"]),
                                        fontWeight: widgetInfo["FontWeight"],
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                          articleContainer.addAll({
                            chiavetta: Padding(
                              padding: EdgeInsets.only(
                                top: double.parse(widgetInfo["Top"]),
                                bottom: double.parse(widgetInfo["Bottom"]),
                                left: double.parse(widgetInfo["Left"]),
                                right: double.parse(widgetInfo["Right"]),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  launch(widgetInfo["Link"]);
                                },
                                child: Text(
                                  widgetInfo["Text"] == null
                                      ? widgetInfo["Link"]
                                      : widgetInfo["Text"],
                                  style: TextStyle(
                                    fontSize: double.parse(widgetInfo["Size"]),
                                    fontWeight: widgetInfo["FontWeight"],
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          });
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          dropdownValue = 1.toString();
                          fontWeight = FontWeight.w300;
                          _textController.clear();
                          _linkController.clear();
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                          _sizeController.clear();
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
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
                        _linkController.clear();
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                        _sizeController.clear();
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      });
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
                  "Aggiungi Link",
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
                          controller: _linkController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Inserire il link",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Link",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Dati Mancanti";
                            } else {
                              widgetInfo["Link"] = value;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _textController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Inserire il testo",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Testo (Opzionale)",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              widgetInfo["Text"] = null;
                            } else {
                              widgetInfo["Text"] = value;
                            }
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
                        final String link = widgetInfo["Link"];
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
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
                                  child: GestureDetector(
                                    onTap: () {
                                      launch(link);
                                    },
                                    child: Text(
                                      widgetInfo["Text"] == null
                                          ? widgetInfo["Link"]
                                          : widgetInfo["Text"],
                                      style: TextStyle(
                                        fontSize:
                                            double.parse(widgetInfo["Size"]),
                                        fontWeight: widgetInfo["FontWeight"],
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                          articleContainer.addAll({
                            chiavetta: Padding(
                              padding: EdgeInsets.only(
                                top: double.parse(widgetInfo["Top"]),
                                bottom: double.parse(widgetInfo["Bottom"]),
                                left: double.parse(widgetInfo["Left"]),
                                right: double.parse(widgetInfo["Right"]),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  launch(widgetInfo["Link"]);
                                },
                                child: Text(
                                  widgetInfo["Text"] == null
                                      ? widgetInfo["Link"]
                                      : widgetInfo["Text"],
                                  style: TextStyle(
                                    fontSize: double.parse(widgetInfo["Size"]),
                                    fontWeight: widgetInfo["FontWeight"],
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          });
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          dropdownValue = 1.toString();
                          fontWeight = FontWeight.w300;
                          _textController.clear();
                          _linkController.clear();
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                          _sizeController.clear();
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
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
                      setState(() {
                        widgetInfo.clear();
                        dropdownValue = 1.toString();
                        fontWeight = FontWeight.w300;
                        _textController.clear();
                        _linkController.clear();
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                        _sizeController.clear();
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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

  addPadding() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Aggiungi Spaziatura",
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
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
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
                                      "Questo testo serve solo per capire la posizione della spaziatura e sarà invisibile!"),
                                ),
                              ),
                            ),
                          );
                          articleContainer.addAll({
                            chiavetta: Padding(
                              padding: EdgeInsets.only(
                                top: double.parse(widgetInfo["Top"]),
                                bottom: double.parse(widgetInfo["Bottom"]),
                                left: double.parse(widgetInfo["Left"]),
                                right: double.parse(widgetInfo["Right"]),
                              ),
                            ),
                          });
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
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
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      });
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
                  "Aggiungi Spaziatura",
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
                        setState(() {
                          _audioController.play("sounds/addedElement.mp4");
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
                                  child: Container(
                                    height: double.parse(widgetInfo["Top"]) +
                                        double.parse(widgetInfo["Bottom"]),
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                            "Questo testo serve solo per capire la posizione della spaziatura e sarà invisibile!"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                          articleContainer.addAll({
                            chiavetta: Padding(
                              padding: EdgeInsets.only(
                                top: double.parse(widgetInfo["Top"]),
                                bottom: double.parse(widgetInfo["Bottom"]),
                                left: double.parse(widgetInfo["Left"]),
                                right: double.parse(widgetInfo["Right"]),
                              ),
                              child: Container(),
                            ),
                          });
                          widgetsInfos.add(widgetInfo);
                          index++;
                          widgetInfo.clear();
                          _leftController.clear();
                          _rightController.clear();
                          _bottomController.clear();
                          _topController.clear();
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
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
                      setState(() {
                        widgetInfo.clear();
                        _leftController.clear();
                        _rightController.clear();
                        _bottomController.clear();
                        _topController.clear();
                      });
                      refreshWorkBench();
                      setState(() {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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

  refreshWorkBench() {
    setState(() {
      print("Refresh");
    });
  }

  cleanWorkBench() {
    setState(() {
      _audioController.play("sounds/BroomEffect.mp3");
      container.clear();
      articleContainer.clear();
      widgetsInfos.clear();
      widgetInfo.clear();
      imagesStorage.clear();
      videoControllersInUse.clear();
      _videoController = null;
      _videoControllerSecondary = null;
    });
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Modificare dati del contenuto ?",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: Text(
                  "Modificare il titolo, la data e la tipologia del contenuto ?",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "Sì",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      getInfoArticle();
                      refreshWorkBench();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
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
                  "Modificare il contenuto ?",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: Text(
                  "Modificare il titolo, la data e la tipologia del contenuto ?",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      "Sì",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      getInfoArticle();
                      refreshWorkBench();
                    },
                  ),
                  TextButton(
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  getInfoArticle() {
    var t = "";
    var d = "";
    String textButton = "Data del contenuto";
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Dati Contenuto",
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
                          controller: _titleController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Inserire il titolo",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Titolo Contenuto",
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
                            t = value;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 24, 37, 102),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Data del contenuto",
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: _dateTime == null
                                  ? DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month - 3,
                                      DateTime.now().day)
                                  : _dateTime,
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor:
                                        const Color.fromARGB(255, 24, 37, 102),
                                    accentColor:
                                        const Color.fromARGB(255, 24, 37, 102),
                                    colorScheme: ColorScheme.light(
                                        primary: const Color.fromARGB(
                                            255, 24, 37, 102)),
                                    buttonTheme: ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary),
                                  ),
                                  child: child,
                                );
                              },
                              firstDate: DateTime(DateTime.now().year,
                                  DateTime.now().month - 3, DateTime.now().day),
                              lastDate: DateTime(2100),
                            );
                            final DateFormat formatter =
                                DateFormat('dd-MM-yyyy');
                            d = formatter.format(date);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Scegliere il tipo di contenuto",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: typeArticle,
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
                              typeArticle = newValue;
                            });
                          },
                          items: elementiArticoli
                              .map((value) => new DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value.toString()),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "CONTINUA",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _titleController.clear();
                          _dateController.clear();
                          title = t;
                          date = d;
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
                      }
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
                  "Info Contenuto",
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
                          controller: _titleController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Inserire il titolo",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Titolo Contenuto",
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
                            t = value;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 24, 37, 102),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              textButton,
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: _dateTime == null
                                  ? DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month - 3,
                                      DateTime.now().day)
                                  : _dateTime,
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor:
                                        const Color.fromARGB(255, 24, 37, 102),
                                    accentColor:
                                        const Color.fromARGB(255, 24, 37, 102),
                                    colorScheme: ColorScheme.light(
                                        primary: const Color.fromARGB(
                                            255, 24, 37, 102)),
                                    buttonTheme: ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary),
                                  ),
                                  child: child,
                                );
                              },
                              firstDate: DateTime(DateTime.now().year,
                                  DateTime.now().month - 3, DateTime.now().day),
                              lastDate: DateTime(2100),
                            );
                            final DateFormat formatter =
                                DateFormat('dd-MM-yyyy');
                            d = formatter.format(date);
                            setState(() {
                              textButton = d;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Scegliere il tipo di contenuto",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: typeArticle,
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
                              typeArticle = newValue;
                            });
                          },
                          items: elementiArticoli
                              .map((value) => new DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value.toString()),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      "CONTINUA",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate() && d.isNotEmpty) {
                        setState(() {
                          _titleController.clear();
                          _dateController.clear();
                          title = t;
                          date = d;
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
                      }
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

  imageStorage(key, imagePath) async {
    final keyInfo = articleContainer[key];
    final link = await addMediaToStorage(imagePath);
    final top = keyInfo["Top"];
    final bottom = keyInfo["Bottom"];
    final left = keyInfo["Left"];
    final right = keyInfo["Right"];
    final isVideo = keyInfo["isVideo"];
    if (!isVideo) {
      imagesChoosen.add(link);
      imageChoosenDropDown = link;
      articleContainer[key] = Padding(
        padding: EdgeInsets.only(
          top: double.parse(top),
          bottom: double.parse(bottom),
          left: double.parse(left),
          right: double.parse(right),
        ),
        child: Image.network(
          link,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) {
            return Image.asset(
              "assets/images/error_image.png",
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            );
          },
        ),
      );
    } else {
      linkStorage.add(link);
      final isSecondary = keyInfo["isSecondary"];
      articleContainer[key] = Padding(
        padding: EdgeInsets.only(
          top: double.parse(top),
          bottom: double.parse(bottom),
          left: double.parse(left),
          right: double.parse(right),
        ),
        child: GestureDetector(
          onTap: isSecondary
              ? () => managerVideocontrollerSecondary()
              : () => managerVideoController(),
          child: Container(
            child: isSecondary
                ? _videoControllerSecondary.value.initialized
                    ? AspectRatio(
                        aspectRatio:
                            _videoControllerSecondary.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            VideoPlayer(_videoControllerSecondary),
                            VideoProgressIndicator(
                              _videoControllerSecondary,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor:
                                    const Color.fromARGB(255, 24, 37, 102),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.black,
                        height: 200,
                        width: 200,
                      )
                : _videoController.value.initialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            VideoPlayer(_videoController),
                            VideoProgressIndicator(
                              _videoController,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor:
                                    const Color.fromARGB(255, 24, 37, 102),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.black,
                        height: 200,
                        width: 200,
                      ),
          ),
        ),
      );
    }
    return;
  }

  saveOnDatabase(String title, String date, String typeArticle,
      String posterImage, Map container) async {
    final contentContainer = container.values.toList().toString();
    Map resultUpload = {
      "Title": title,
      "Date": date,
      "PosterImage": posterImage,
      "Content": contentContainer,
      "VideoLink": linkStorage.toString(),
    };
    try {
      var databaseReference =
          widget.database.reference().child(typeArticle + "/" + title);
      databaseReference.set(resultUpload);
      return true;
    } catch (e) {
      print("An error occurred while posting on database : $e");
      return false;
    }
  }

  getPosterImage() async {
    setState(() {
      widgetInfo.addAll({"ImageLink": null});
      widgetInfo.addAll({"ImagePath": null});
    });
    if (Platform.isIOS) {
      await showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              widgetInfo.addAll({"ImageLink": ""});
              widgetInfo.addAll({"ImagePath": ""});
              return CupertinoAlertDialog(
                title: Text(
                  "Aggiungi Immagine di Copertina",
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
                          controller: _linkController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Inserire il link",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Link",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (value) {
                            final result = value.isNotEmpty;
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                descriptionButtonCamera = "Scegli Foto";
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                                containerImage = Image.network(
                                  value,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  height: 200,
                                  width: 200,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Image.asset(
                                      "assets/images/error_image.png",
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                      width: 200,
                                      height: 200,
                                    );
                                  },
                                );
                              }
                            });
                            refreshWorkBench();
                          },
                          validator: (value) {
                            if (imageChoosenDropDown.isEmpty) {
                              return "Dati Mancanti";
                            } else if (value.isNotEmpty) {
                              imageChoosenDropDown = widgetInfo["ImageLink"];
                              isALink = true;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getImageFromCamera();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionButtonCamera = "Foto Selezionata";
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                                imageChoosenDropDown = widgetInfo["ImagePath"];
                                isALink = false;
                                containerImage = Image.network(
                                  imageChoosenDropDown,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  height: 200,
                                  width: 200,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Image.asset(
                                      "assets/images/error_image.png",
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                      width: 200,
                                      height: 200,
                                    );
                                  },
                                );
                              } else {
                                descriptionButtonCamera = "Scatta Foto";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionButtonCamera,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getImageFromGallery();
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionButtonGallery = "Foto Selezionata";
                                descriptionButtonCamera = "Scatta Foto";
                                imageChoosenDropDown = widgetInfo["ImagePath"];
                                isALink = false;
                                containerImage = Image.network(
                                  imageChoosenDropDown,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  height: 200,
                                  width: 200,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Image.asset(
                                      "assets/images/error_image.png",
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                      width: 200,
                                      height: 200,
                                    );
                                  },
                                );
                              } else {
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionButtonGallery,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure Scegli tra quelli già salvati",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: imageChoosenDropDown,
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
                              imageChoosenDropDown = newValue;
                              _linkController.clear();
                              isALink = true;
                              containerImage = Image.network(
                                imageChoosenDropDown,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                                height: 200,
                                width: 200,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Image.asset(
                                    "assets/images/error_image.png",
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter,
                                    width: 200,
                                    height: 200,
                                  );
                                },
                              );
                            });
                          },
                          items: imagesChoosen
                              .map((value) => new DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value.toString()),
                                  ))
                              .toList(),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        containerImage,
                        SizedBox(
                          height: 15,
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
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String newLink;
                        if (!isALink) {
                          newLink = await addMediaToStorage(posterImage);
                        }
                        setState(() {
                          if (!isALink) {
                            imageChoosenDropDown = newLink;
                          }
                          widgetInfo.clear();
                          _linkController.clear();
                          descriptionButtonGallery = "Scegli Foto Galleria";
                          descriptionButtonCamera = "Scatta Foto";
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "Aggiungi Immagine di Copertina",
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
                          controller: _linkController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Inserire il link",
                            hintStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            border: OutlineInputBorder(),
                            labelText: "Link",
                            labelStyle: TextStyle(
                              fontSize: 23.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          onChanged: (value) {
                            final result = value.isNotEmpty;
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                descriptionButtonCamera = "Scegli Foto";
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                                containerImage = Image.network(
                                  value,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  height: 200,
                                  width: 200,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Image.asset(
                                      "assets/images/error_image.png",
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                      width: 200,
                                      height: 200,
                                    );
                                  },
                                );
                              }
                            });
                            refreshWorkBench();
                          },
                          validator: (value) {
                            if (posterImage.toString().isEmpty) {
                              return "Dati Mancanti";
                            } else if (value.isNotEmpty) {
                              posterImage = widgetInfo["ImageLink"];
                              isALink = true;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getImageFromCamera();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionButtonCamera = "Foto Selezionata";
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                                posterImage = widgetInfo["ImagePath"];
                                isALink = false;
                                containerImage = Image.file(
                                  posterImage,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  width: 200,
                                );
                              } else {
                                descriptionButtonCamera = "Scatta Foto";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionButtonCamera,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await getImageFromGallery();
                            refreshWorkBench();
                            setState(() {
                              if (result) {
                                _linkController.clear();
                                descriptionButtonGallery = "Foto Selezionata";
                                descriptionButtonCamera = "Scatta Foto";
                                posterImage = widgetInfo["ImagePath"];
                                isALink = false;
                                containerImage = Image.file(
                                  posterImage,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  width: 200,
                                );
                              } else {
                                descriptionButtonGallery =
                                    "Scegli Foto Galleria";
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  descriptionButtonGallery,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Oppure Scegli tra quelli già salvati",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: imageChoosenDropDown,
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
                              imageChoosenDropDown = newValue;
                              posterImage = imageChoosenDropDown;
                              _linkController.clear();
                              isALink = true;
                              descriptionButtonGallery = "Scegli Foto Galleria";
                              descriptionButtonCamera = "Scatta Foto";
                              containerImage = Image.network(
                                imageChoosenDropDown,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                                width: 200,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace stackTrace) {
                                  return Image.asset(
                                    "assets/images/error_image.png",
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter,
                                    width: 200,
                                    height: 200,
                                  );
                                },
                              );
                            });
                          },
                          items: imagesChoosen
                              .map((value) => new DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value.toString()),
                                  ))
                              .toList(),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        containerImage,
                        SizedBox(
                          height: 15,
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
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String newLink;
                        if (!isALink) {
                          newLink = await addMediaToStorage(posterImage);
                        }
                        setState(() {
                          if (!isALink) {
                            posterImage = newLink;
                          }
                          widgetInfo.clear();
                          _linkController.clear();
                          descriptionButtonGallery = "Scegli Foto Galleria";
                          descriptionButtonCamera = "Scatta Foto";
                        });
                        refreshWorkBench();
                        setState(() {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        });
                      }
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

  saveWorkBench() async {
    bool continuare = false;
    if (Platform.isIOS) {
      await showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Confermare il salvataggio ?",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: Text(
                  widget.isManager
                      ? "Confermare il salvataggio e la pubblicazione del contenuto ? Proseguendo il contenuto verrà pubblicato e l'area di lavoro ripulita!"
                      : "Confermare il salvataggio e la richiesta di pubblicazione del contenuto ? Proseguendo verrà richiesta la pubblicazione del contenuto e l'area di lavoro sarà ripulita!",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "Sì",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      continuare = true;
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      continuare = false;
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "Confermare il salvataggio ?",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: Text(
                  widget.isManager
                      ? "Confermare il salvataggio e la pubblicazione del contenuto ? Proseguendo il contenuto verrà pubblicato e l'area di lavoro ripulita!"
                      : "Confermare il salvataggio e la richiesta di pubblicazione del contenuto ? Proseguendo verrà richiesta la pubblicazione del contenuto e l'area di lavoro sarà ripulita!",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      "Sì",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      continuare = true;
                    },
                  ),
                  TextButton(
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      continuare = false;
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Salvataggio contenuto...');
    await dialog.show();
    if (!continuare) {
      return;
    }
    final List values = imagesStorage.values.toList();
    final List keys = imagesStorage.keys.toList();
    int index = 0;
    for (var k in keys) {
      var val = values[index];
      await imageStorage(k, val);
      index++;
    }
    await dialog.hide();
    await getPosterImage();
    await dialog.show();
    final resultDb = await saveOnDatabase(
        title, date, typeArticle, posterImage, articleContainer);
    setState(() {
      _audioController.play("sounds/saveNotification.mp3");
      container.clear();
      articleContainer.clear();
      widgetsInfos.clear();
      widgetInfo.clear();
      imagesStorage.clear();
      videoControllersInUse.clear();
      _videoController = null;
      _videoControllerSecondary = null;
    });
    await dialog.hide();
    if (Platform.isIOS) {
      showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return CupertinoAlertDialog(
                title: Text(
                  "Esito Salvataggio",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: Text(
                  resultDb
                      ? "Salvataggio completato con successo !"
                      : "Ops... Si è verificato un'errore durante il salvataggio !",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
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
                  "Esito Salvataggio",
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                content: Text(
                  resultDb
                      ? "Salvataggio completato con successo !"
                      : "Ops... Si è verificato un'errore durante il salvataggio !",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
    return;
  }

  setElements() {
    setState(() {
      _duration = 600;
      _width = 0;
      show = false;
      _left = MediaQuery.of(context).size.width - 65;
    });
    getInfoArticle();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setElements());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    _videoControllerSecondary.dispose();
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
                              height: 150,
                              width: ((MediaQuery.of(context).size.width * 75) /
                                      100) -
                                  50,
                              curve: Curves.fastLinearToSlowEaseIn,
                              decoration: BoxDecoration(
                                color: containerColorEvidence,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: colorEvidence,
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
                              colorEvidence = Colors.white;
                              containerColorEvidence = Colors.white;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                top: (MediaQuery.of(context).size.height * 38) / 100,
                left: _left,
                duration: Duration(milliseconds: _duration),
                child: FloatingActionButton(
                  heroTag: null,
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
                                      colorEvidence = Colors.blueAccent;
                                      containerColorEvidence =
                                          Color.fromARGB(100, 135, 206, 250);
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
                                      colorEvidence = Colors.white;
                                      containerColorEvidence = Colors.white;
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                top: (MediaQuery.of(context).size.height * 2) / 100,
                left: _left,
                duration: Duration(milliseconds: _duration),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    cleanWorkBench();
                  },
                  child: Icon(
                    Icons.cleaning_services_outlined,
                    size: 35,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 24, 37, 102),
                ),
              ),
              AnimatedPositioned(
                top: (MediaQuery.of(context).size.height * 78) / 100,
                left: _left,
                duration: Duration(milliseconds: _duration),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    saveWorkBench();
                  },
                  child: Icon(
                    Icons.save,
                    size: 35,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 24, 37, 102),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
