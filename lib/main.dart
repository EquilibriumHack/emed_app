import 'dart:async';

import 'package:emed/doctors.dart';
import 'package:emed/notifications.dart';
import 'package:emed/pharmacy.dart';
import 'package:emed/signin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shake/shake.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Lato",
      ),
      home: const MyHomePage(title: 'eMed'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var emergency = false;
  @override
  Future<void> _showAlertDialog(BuildContext context) async {
    var BOT_TOKEN = '5486059857:AAFqrDLAJj_1aKkatcR_nRNeH5aZYi1KdQM';
    final username = (await Telegram(BOT_TOKEN).getMe()).username;
    var teledart = TeleDart(BOT_TOKEN, Event(username!));
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        // title: const Text('fsd'),
        content: const Text(
          "O'zigizni qanday his qilayabsiz? 3 daqiqa davomida javob qaytarmasangiz malumotlaringiz avtomatik ravishda tekshiruvga yuboriladi",
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                emergency = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Keyingi safar extiyot bo\'ling'),
                ),
              );
            },
            child: const Text("Yaxshi :)"),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              teledart.sendLocation(
                -737408094,
                position.latitude,
                position.longitude,
              );
              teledart.sendMessage(
                -737408094,
                "‼️Diqqat\n\n🆘Favqulotda Holat\n\n✅Ism/Familyasi: Shohabbos\n\n✅Telefon raqami: +998941701078\n\n‼️Yuqoridagi manzilda shaxsning ahvoli og'irlashgani haqida xabar berildi",
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Malumotlaringiz yubirildi!",
                  ),
                ),
              );
            },
            child: const Text('Yomon :('),
          )
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();

    ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          emergency = true;
        });
        Clipboard.setData(ClipboardData(text: "data"));
        HapticFeedback.heavyImpact();
        HapticFeedback.vibrate();
        _showAlertDialog(context);
        Timer(Duration(seconds: 5), () {
          if (emergency) {
            print("Call to 911");
          } else {
            print('Hammasi joyida');
          }
        });
        //show bottomsheet with 2 buttons
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );

    // To close: detector.stopListening();
    // ShakeDetector.waitForStart() waits for user to call detector.startListening();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          print('Harakat aniqlandi');

          emergency = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notifications(),
                  ),
                );
              },
              icon: const Icon(
                FontAwesomeIcons.bell,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                FontAwesomeIcons.bars,
                color: Colors.green,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignIn(),
                ),
              );
            },
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.green,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              //circular image
              Row(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 42,
                      child: ClipRRect(
                        child: Image.asset(
                          "images/avatar.png",
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 42,
                    width: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Mening profilim",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Divider(
                thickness: 3,
                endIndent: 280,
                color: Colors.grey,
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Salom ",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const TextSpan(
                      text: "Shohabbos\n",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: "Sizga qanday yordam bera olamiz? ",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 3,
                endIndent: 280,
                color: Colors.grey,
                height: 20,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Doctors(),
                        ),
                      );
                    },
                    child: Card(
                      cardColor: Colors.blue[400],
                      text: "Doktorlar",
                      icon: FontAwesomeIcons.userDoctor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Pharmacy(),
                        ),
                      );
                    },
                    child: Card(
                      cardColor: Colors.green[400],
                      text: "Dorixonalar",
                      icon: FontAwesomeIcons.pills,
                    ),
                  ),
                  const Card(
                    cardColor: Colors.red,
                    text: "Kasalxonalar",
                    icon: FontAwesomeIcons.houseChimneyMedical,
                  ),
                ],
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "COVID - 19",
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: "Lato",
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              width: 160,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                              ),
                              child: const Text(
                                "Covid - 19 ga qarshi emlanishning so'ngi bosqichiga 5 kun qoldi",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Lato",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: Icon(
                            FontAwesomeIcons.virusCovid,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 180,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Malumot olish",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Lato",
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              GestureDetector(
                onTap: () async {
                  var BOT_TOKEN =
                      '5486059857:AAFqrDLAJj_1aKkatcR_nRNeH5aZYi1KdQM';
                  final username = (await Telegram(BOT_TOKEN).getMe()).username;
                  var teledart = TeleDart(BOT_TOKEN, Event(username!));
                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );
                  teledart.sendLocation(
                    -737408094,
                    position.latitude,
                    position.longitude,
                  );
                  teledart.sendMessage(
                    -737408094,
                    "‼️Diqqat\n\n🆘Favqulotda Holat\n\n✅Ism/Familyasi: Shohabbos\n\n✅Telefon raqami: +998941701078\n\n‼️Yuqoridagi manzilda shaxsning ahvoli og'irlashgani haqida xabar berildi",
                  );
                },
                child: Container(
                  height: 64,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Tez yordam",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Lato",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    Key? key,
    this.cardColor,
    this.text,
    this.icon,
  }) : super(key: key);
  final cardColor;
  final text;
  final icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Lato",
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
