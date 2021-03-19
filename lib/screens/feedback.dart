import 'package:fdmCreator/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mailer2/mailer.dart';

class FeedBack extends StatefulWidget {
  static const String routeName = "/feedback";

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  double ratingValue;
  String feedBack;
  final _feedBackController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    sendFeedBack(String feedBack, double rating) async {
      var options = new GmailSmtpOptions()
        ..username = 'ermes.express.fdm@gmail.com'
        ..password = 'CASTELLO1967';

      var emailTransport = new SmtpTransport(options);

      var envelope = new Envelope()
        ..from = 'ermes.express.fdm@gmail.com'
        ..recipients.add('theprogxy@gmail.com') //utilizza mail apposita
        ..subject = 'FeedBack - fdmCreator'
        ..text = "FeedBack:\n" +
            feedBack +
            "\n\nRating: " +
            rating.toString() +
            "\n\nErmes-Express FDM";

      emailTransport.send(envelope).then((envelope) {
        if (isIOS) {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                "Grazie per la Recensione!",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              content: Text(
                "Provvederemo a prendere in esame i problemi ed i suggerimenti.\nLa Fondazione Don Milani.",
                style: TextStyle(
                  fontSize: 27,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Text(
                    "Vai alla HomePage",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(
                "Grazie per la Recensione!",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              content: Text(
                "Provvederemo a prendere in esame i problemi ed i suggerimenti.\nLa Fondazione Don Milani.",
                style: TextStyle(
                  fontSize: 27,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Text(
                    "Vai alla HomePage",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                )
              ],
            ),
          );
        }
      }).catchError((e) {
        print("Error : $e");
        if (isIOS) {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                "Errore",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              content: Text(
                "Ops... Qualcosa è andato storto!\nNon è stato possibile inviare la email!",
                style: TextStyle(
                  fontSize: 27,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                )
              ],
            ),
          );
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(
                "Errore",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              content: Text(
                "Ops... Qualcosa è andato storto!\nNon è stato possibile inviare la email!",
                style: TextStyle(
                  fontSize: 27,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                )
              ],
            ),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 192, 192, 192),
        ),
        title: Text(
          "Feedback",
          style: TextStyle(
            color: Color.fromARGB(255, 192, 192, 192),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 24, 37, 102),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Text(
                  "Come Valuti l'Applicazione: ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                ),
                child: Center(
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      ratingValue = rating;
                    },
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 15,
                  ),
                  child: Text(
                    "Inserire dei Suggerimenti o dei Problemi riscontrati: ",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _feedBackController,
                maxLines: 15,
                decoration: const InputDecoration(
                  hintText: "Digitare Qui...",
                  hintStyle: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  border: OutlineInputBorder(),
                  labelText: "FeedBack",
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
                  feedBack = value;
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                ),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      primary: Color.fromARGB(255, 24, 37, 102),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        sendFeedBack(feedBack, ratingValue);
                      } else {
                        if (isIOS) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: Text(
                                "Errore",
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              content: Text(
                                "Dati Mancanti!",
                                style: TextStyle(
                                  fontSize: 27,
                                ),
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                )
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                "Errore",
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              content: Text(
                                "Dati Mancanti!",
                                style: TextStyle(
                                  fontSize: 27,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                )
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Invia Feedback",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
