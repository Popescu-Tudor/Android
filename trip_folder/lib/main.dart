import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_folder/details.dart';
import 'package:trip_folder/trip.dart';
import 'package:trip_folder/trips_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip list app',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(58, 59, 60, 1)),
      home: Scaffold(body: TriplistView()),
    );
  }
}

class TriplistView extends StatefulWidget {
  const TriplistView({Key? key}) : super(key: key);

  @override
  State<TriplistView> createState() => _TriplistViewState();
}

class _TriplistViewState extends State<TriplistView> {
  late var _tripList = <Trip>[];
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    refreshTrips();
  }

  @override void dispose() {
    TripsDatabase.instance.close();

    super.dispose();
  }

  Future refreshTrips() async {
    setState(() {
      isLoading = true;
    });
    try {
      _tripList = await TripsDatabase.instance.readAllTrips();
    } catch (error){
      if (kDebugMode) {
        print(error);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void saveTrip(Trip trip) {
    bool found = false;

    for (Trip w in _tripList) {
      if (w.tripId == trip.tripId) {
        setState(() {
          w.title = trip.title;
          w.description = trip.description;
          w.creationDate = trip.creationDate;
          w.finishingDate = trip.finishingDate;
          w.startingDate = trip.startingDate;
          w.state = trip.state;
          w.price = trip.price;
        });
        found = true;
      }
    }
  }

  void deleteTrip(int tripId){
    for(Trip w in _tripList){
      if(w.tripId == tripId){
        setState(() {
          _tripList.remove(w);
        });

        break;
      }
    }
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 30),
            itemCount: _tripList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _tripList[index];

              // CHOOSING THE STATE IMAGE
              String imageStringURL;
              switch (item.state) {
                case "Abandoned":
                  {
                    imageStringURL = "images/abandoned_icon.png";
                  }
                  break;
                case "Finished":
                  {
                    imageStringURL = "images/finished_icon.png";
                  }
                  break;
                default:
                  {
                    imageStringURL = "images/in_progress_icon.png";
                  }
                  break;
              }

              // CHOOSING THE PRIORITY COLOR
              Color priorityColor;
              switch (item.price) {
                case "Luxury ( > 10000 \$)":
                  {
                    priorityColor = Colors.black;
                  }
                  break;
                case "Expensive+ ( > 5000 \$)":
                  {
                    priorityColor = Colors.red;
                  }
                  break;
                case "Expensive ( > 2500 \$)":
                  {
                    priorityColor = Colors.grey;
                  }
                  break;
                case "Normal (~1000 \$)":
                  {
                    priorityColor = Colors.yellow;
                  }
                  break;
                case "Cheap ( < 500 \$)":
                  {
                    priorityColor = Colors.green;
                  }
                  break;
                case "Cheap- ( < 100 \$)":
                  {
                    priorityColor = Colors.white;
                  }
                  break;
                default:
                  {
                    priorityColor = Colors.blue;
                  }
                  break;
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details( refreshState: refreshTrips,
                            trip: _tripList[index], saveAction: saveTrip, deleteAction: deleteTrip, newTrip: false,)));
                },
                child: ListTile(
                  title: Container(
                    color: const Color.fromRGBO(228, 230, 235, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(item.title,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ),
                            ),
                            Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      imageStringURL,
                                      width: 50,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(item.description,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(fontSize: 16)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Created at: ${item.creationDate}",
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(fontSize: 14)),
                        ),
                        Container(
                          width: double.infinity,
                          height: 13,
                          color: priorityColor,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, bottom: 20, right: 20),
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              icon: Image.asset('images/plus_sign.png'),
              iconSize: 40,
              color: const Color.fromRGBO(134, 75, 56, 1),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Details(
                            refreshState: refreshTrips,
                            trip: Trip(
                                tripId: null,
                                title: "Trip title",
                                description: "Trip description",
                                price: "Normal (~1000 \$)",
                                creationDate: DateTime.now(),
                                startingDate: DateTime.now().add(const Duration(days: 1)),
                                finishingDate: null,
                                state: "In progress"),
                            saveAction: saveTrip, deleteAction: deleteTrip, newTrip: false)));
              },
            ),
          ),
        )
      ]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}


