import 'package:connectivity/connectivity.dart';
import 'package:fdmCreator/screens/contentWorkBench.dart';
import 'package:flutter/material.dart';

import '../accountInfo.dart';
import 'badConnection.dart';
import 'cambioPassword.dart';
import 'home.dart';
import 'notificationsCreator.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final int version = 0;
  final int subVersion = 1;
  final String beta = "Beta";
  final String name = AccountInfo.name;
  final String email = AccountInfo.email;
  final bool isManager = AccountInfo.isManager;
  GlobalKey _finalWidgetKey = GlobalKey();
  GlobalKey _widgetKey = GlobalKey();
  double heightArea = 0.0;
  getPosition() {
    double height = MediaQuery.of(context).size.height;
    RenderBox box = _finalWidgetKey.currentContext.findRenderObject();
    Offset position = box.localToGlobal(Offset.zero);
    double y = position.dy;
    setState(() {
      heightArea = height - y;
      heightArea -= 115;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getPosition());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              child: Image(
                  image: AssetImage("assets/images/don_milani.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 24, 37, 102),
                      child: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 192, 192, 192),
                      ),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 8, top: 3),
                        child: Text(
                          "$name",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30, left: 8),
                        child: Text(
                          "$email",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Home", style: TextStyle(fontSize: 23)),
              onTap: () async {
                var connectivityResult =
                    await (Connectivity().checkConnectivity());
                if (connectivityResult == ConnectivityResult.none) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BadConnection()));
                } else {
                  Navigator.pushReplacementNamed(context, Home.routeName);
                }
              },
            ),
            ListTile(
              key: isManager ? _widgetKey : _finalWidgetKey,
              title: Text("Crea Contenuti", style: TextStyle(fontSize: 23)),
              onTap: () async {
                var connectivityResult =
                    await (Connectivity().checkConnectivity());
                if (connectivityResult == ConnectivityResult.none) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BadConnection()));
                } else {
                  Navigator.pushReplacementNamed(
                      context, CreateContent.routeName);
                }
              },
            ),
            isManager
                ? ListTile(
                    title:
                        Text("Cambio Password", style: TextStyle(fontSize: 23)),
                    onTap: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BadConnection()));
                      } else {
                        Navigator.pushReplacementNamed(
                            context, CambioPassword.routeName);
                      }
                    },
                  )
                : SizedBox(
                    height: 1,
                  ),
            isManager
                ? ListTile(
                    key: _finalWidgetKey,
                    title:
                        Text("Crea Notifica", style: TextStyle(fontSize: 23)),
                    onTap: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BadConnection()));
                      } else {
                        Navigator.pushReplacementNamed(
                            context, NotificationsCreator.routeName);
                      }
                    },
                  )
                : SizedBox(
                    height: 1,
                  ),
            Padding(
              padding: EdgeInsets.only(
                top: heightArea,
              ),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 24, 37, 102),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 17),
                  child: Text(
                    "Versione $beta $version.$subVersion",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
