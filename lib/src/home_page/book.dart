import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_uber/src/constants/images.dart';
import 'package:flutter_firebase_uber/src/global_widgets/buttons_widget.dart';
import 'package:flutter_firebase_uber/src/map_widget/mapwidget.dart';
import 'package:flutter_firebase_uber/src/style.dart';
import 'package:flutter_svg/svg.dart';

enum Rides { mini, standard, luxury, suv }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _fromTextEditingController =
      TextEditingController();

  final TextEditingController _toTextEditingController =
      TextEditingController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String? selectedRide = 'shared';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            height: 40,
            width: 55,
            decoration: BoxDecoration(
              // color: Colors.red,
              image: const DecorationImage(
                image: AssetImage('assets/images/avatar.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.red,
                )
              ],
            ),
          ),
        ],
        leading: IconButton(
            icon: SvgPicture.asset('assets/images/Burger.svg'),
            onPressed: () => _key.currentState!.openDrawer()),
      ),
      drawer: Drawer(
          child: ListView(children: const <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(),
      ])),
      body: Stack(
        // to have a gradient behind the avatar and the burger menu
        children: [
          const MapWidget(),
          Container(
              height: 110,
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.white10,
                  Colors.white.withOpacity(0.1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ))),
          _hoveringRideCard(context)
        ],
      ),
    );
  }

  _hoveringRideCard(context) {
    return Positioned(
      bottom: 120,
      left: 30,
      right: 30,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(children: [
          // from to input
          Expanded(
              flex: 3,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      top: 40.0, bottom: 38, left: 8),
                                  child: FDottedLine(
                                    color: Colors.grey,
                                    height: 80.0,
                                    strokeWidth: 2.0,
                                    dottedLength: 2.0,
                                    space: 2.0,
                                  )),
                              const SizedBox(
                                width: 8,
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.stars_rounded,
                                  color: mainColor,
                                ),
                                padding: const EdgeInsets.only(right: 10),
                              ),

                              //real time search or select from map
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height: double.infinity,
                                  child: const Text(
                                    'From: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: TextField(
                                controller: _fromTextEditingController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              )),
                            ],
                          )),
                          Expanded(
                              child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.stars_rounded,
                                  color: Colors.grey[800],
                                ),
                                padding: const EdgeInsets.only(right: 10),
                              ),

                              //real time search or select from map
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height: double.infinity,
                                  child: const Text(
                                    'To: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: SizedBox(
                                child: TextField(
                                  controller: _toTextEditingController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              )),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ))),

          //service selection
          Expanded(flex: 6, child: _chooseACar(context)),

          //order
          Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    GeneralButton(
                      text: 'BOOK',
                      onPressed: () => debugPrint('Ride booked'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: GeneralButton(
                        width: 120,
                        text: 'CANCEL',
                        color: const Color(0xFFEB5757),
                        onPressed: () => debugPrint('canceled'),
                      ),
                    )
                  ],
                ),
              ))
        ]),
      ),
    );
  }

  _chooseACar(context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRide = 'mini';
                  });
                  debugPrint(selectedRide);
                },
                child: _carCard(
                  color: selectedRide!.toLowerCase() == 'mini'
                      ? mainColor
                      : null,
                  title: 'mini',
                  subTitle: 'small cab',
                  price: 5000,
                  imageUrl: miniCarImageUrl, 
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRide = 'Standard';
                  });
                },
                child: _carCard(
                  color: selectedRide!.toLowerCase() == 'standard'
                      ? mainColor
                      : null,
                  title: 'Standard',
                  subTitle: 'Affordable rides',
                  price: 25000,
                  imageUrl:
                      standardCarImageUrl, 
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRide = 'Luxury';
                  });
                },
                child: _carCard(
                  color: selectedRide!.toLowerCase() == 'luxury'
                      ? mainColor
                      : null,
                  title: 'Luxury',
                  subTitle: 'Luxury rides',
                  price: 60000,
                  imageUrl: luxuryCarImageUrl, 
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedRide = 'suv';
                });
              },
              child: _carCard(
                title: 'SUV',
                color: selectedRide!.toLowerCase() == 'suv'
                    ? mainColor
                    : null,
                subTitle: 'Suv vehicles',
                price: 25000, 
                imageUrl: suvImageUrl, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _carCard(
      {String? title,
      String? subTitle,
      num? price,
      String? imageUrl,
      Color? color}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //title
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title!.toUpperCase(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color:
                                    color == mainColor ? Colors.white : null),
                          ),
                        ),
                        //subtitle
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subTitle!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color:
                                    color == mainColor ? Colors.white : null),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      //price
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "IQD $price",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: color == mainColor
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      //spacer
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
