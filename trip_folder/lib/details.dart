import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trip_folder/trip.dart';
import 'package:trip_folder/trips_database.dart';

class Details extends StatefulWidget {
  const Details(
      {Key? key,
      required this.trip,
      required this.saveAction,
      required this.deleteAction,
      required this.refreshState,
      required this.newTrip})
      : super(key: key);

  final Trip trip;
  final Function(Trip) saveAction;
  final Function(int) deleteAction;
  final Function() refreshState;
  final bool newTrip;
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final GlobalKey<_EstimatedFulfilledDatePickerState>
      estimatedFulfilledDateKey =
      GlobalKey<_EstimatedFulfilledDatePickerState>();
  final GlobalKey<_FulfilledDatePickerState> fulfilledDateKey =
      GlobalKey<_FulfilledDatePickerState>();
  final GlobalKey<_PriorityDropdownState> priorityGlobalKey =
      GlobalKey<_PriorityDropdownState>();
  final GlobalKey<_StateDropdownState> stateGlobalKey =
      GlobalKey<_StateDropdownState>();

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.trip.title;
    descriptionController.text = widget.trip.description;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5),
                  child: IconButton(
                    padding: const EdgeInsets.all(0.0),
                    icon: Image.asset('images/go_back_icon.png'),
                    iconSize: 40,
                    color: const Color.fromRGBO(134, 75, 56, 1),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 210.0, bottom: 5),
                  child: IconButton(
                    padding: const EdgeInsets.all(0.0),
                    icon: Image.asset('images/thrash_icon.png'),
                    iconSize: 40,
                    color: const Color.fromRGBO(134, 75, 56, 1),
                    onPressed: () {
                      showAlertDialog(context);
                    },
                  )),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5),
            child: Text("Title:",
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromRGBO(217, 217, 217, 1),
                hintText: 'Enter a title',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5),
            child: Text("Description:",
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 5,
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromRGBO(217, 217, 217, 1),
                hintText: 'Enter a title',
              ),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5),
                child: Text("Price:",
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              PriorityDropdown(
                  key: priorityGlobalKey, chosenValue: widget.trip.price)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5),
            child: Text("Created at: ${widget.trip.creationDate}",
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
          ),
          EstimatedFulfilledDatePicker(
              key: estimatedFulfilledDateKey, finalDate: widget.trip.startingDate),
          FulfilledDatePicker(
              key: fulfilledDateKey, fulfilledDate: widget.trip.finishingDate),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5),
                child: Text("State:",
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              StateDropdown(key: stateGlobalKey, chosenValue: widget.trip.state)
            ],
          ),
          TextButton(
              onPressed: () async {
                try {
                  if (widget.trip.tripId == null) {
                    TripsDatabase.instance.create(Trip(
                        tripId: null,
                        title: titleController.text,
                        description: descriptionController.text,
                        price: priorityGlobalKey.currentState
                            ?.dropdownValue ??
                            "Normal (~1000 \$)",
                        creationDate: widget.trip.creationDate,
                        startingDate:
                        estimatedFulfilledDateKey.currentState?.selectedDate,
                        finishingDate: fulfilledDateKey.currentState
                            ?.selectedDate,
                        state: stateGlobalKey.currentState?.dropdownValue ??
                            "In progress"));
                  }
                  else {
                    TripsDatabase.instance.update(Trip(
                        tripId: widget.trip.tripId,
                        title: titleController.text,
                        description: descriptionController.text,
                        price: priorityGlobalKey.currentState
                            ?.dropdownValue ??
                            "Normal (~1000 \$)",
                        creationDate: widget.trip.creationDate,
                        startingDate:
                        estimatedFulfilledDateKey.currentState?.selectedDate,
                        finishingDate: fulfilledDateKey.currentState
                            ?.selectedDate,
                        state: stateGlobalKey.currentState?.dropdownValue ??
                            "In progress"));
                  }
                } catch (error){
                  showSimpleAlert(context);
                  if (kDebugMode) {
                    print(error);
                  }
                }
                widget.refreshState();
                Navigator.pop(context);
              },
              child: Container(
                  width: 300,
                  height: 50,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  )))
        ]),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        try {
          TripsDatabase.instance.delete(widget.trip.tripId);
          widget.refreshState();
        } catch (error){
        showSimpleAlert(context);
        if (kDebugMode) {
          print(error);
        }
      }

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting"),
      content: Text("Are you sure you want to delete the trip?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSimpleAlert(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("The action was not able to be finished because of an error. Please send an email to xxx.support@gmail.com"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class FulfilledDatePicker extends StatefulWidget {
  const FulfilledDatePicker({Key? key, required this.fulfilledDate})
      : super(key: key);

  final DateTime? fulfilledDate;
  @override
  State<FulfilledDatePicker> createState() => _FulfilledDatePickerState();
}

class _FulfilledDatePickerState extends State<FulfilledDatePicker> {
  // FULFILLED DATE PICKER
  late DateTime? selectedDate = widget.fulfilledDate;

  Future<void> _selectFulfilledDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5),
          child: Text("Finishing date: ${selectedDate ?? null}",
              overflow: TextOverflow.fade,
              maxLines: 3,
              softWrap: true,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
      TextButton(
        onPressed: () => _selectFulfilledDate(context),
        child: Text('Select date'),
      )
    ]);
  }
}

class EstimatedFulfilledDatePicker extends StatefulWidget {
  const EstimatedFulfilledDatePicker({Key? key, required this.finalDate})
      : super(key: key);

  final DateTime? finalDate;
  @override
  State<EstimatedFulfilledDatePicker> createState() =>
      _EstimatedFulfilledDatePickerState();
}

class _EstimatedFulfilledDatePickerState
    extends State<EstimatedFulfilledDatePicker> {
  // FULFILLED DATE PICKER
  late DateTime? selectedDate = widget.finalDate;

  Future<void> _selectFulfilledDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 5),
          child: Text("Starting date: ${selectedDate ?? "null"}",
              overflow: TextOverflow.fade,
              maxLines: 3,
              softWrap: true,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
      TextButton(
        onPressed: () => _selectFulfilledDate(context),
        child: Text('Select date'),
      )
    ]);
  }
}

const List<String> priorities = <String>[
  'Luxury ( > 10000 \$)',
  'Expensive+ ( > 5000 \$)',
  'Expensive ( > 2500 \$)',
  'Normal (~1000 \$)',
  "Cheap ( < 500 \$)",
  "Cheap- ( < 100 \$)"
];

class PriorityDropdown extends StatefulWidget {
  const PriorityDropdown({super.key, required this.chosenValue});

  final String chosenValue;

  @override
  State<PriorityDropdown> createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  late String dropdownValue = widget.chosenValue;
  String get priorityValue => dropdownValue;

  Color choosePriorityColor(String priority) {
    Color priorityColor;
    switch (priority) {
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
    return priorityColor;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Colors.grey,
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 0,
      style: const TextStyle(color: Color.fromRGBO(217, 217, 217, 1)),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: priorities.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      color: choosePriorityColor(value),
                      width: 40,
                      height: 15,
                    ),
                  )
                ],
              ),
            ));
      }).toList(),
    );
  }
}

const List<String> states = <String>[
  'Finished',
  'Abandoned',
  'In progress',
];

class StateDropdown extends StatefulWidget {
  const StateDropdown({super.key, required this.chosenValue});

  final String chosenValue;

  @override
  State<StateDropdown> createState() => _StateDropdownState();
}

class _StateDropdownState extends State<StateDropdown> {
  late String dropdownValue = widget.chosenValue;

  String chooseStateIcon(String value) {
    // CHOOSING THE STATE IMAGE
    String imageStringURL;
    switch (value) {
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
    return imageStringURL;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: Colors.grey,
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 0,
      style: const TextStyle(color: Color.fromRGBO(217, 217, 217, 1)),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: states.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      chooseStateIcon(value),
                      width: 50,
                      height: 15,
                    ),
                  )
                ],
              ),
            ));
      }).toList(),
    );
  }
}
