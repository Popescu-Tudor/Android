final String tableTrips = 'trips';

class TripFields{
  static final List<String> values = [
    tripId, title, description, price, creationDate, startingDate, finishingDate, state
  ];
  static final String tripId = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String price = 'price';
  static final String creationDate = 'creationDate';
  static final String startingDate = 'startingDate';
  static final String finishingDate = 'finishingDate';
  static final String state = 'state';
}

class Trip {


  int? tripId;
  String title;
  String description;
  String price;
  DateTime creationDate;
  DateTime? startingDate;
  DateTime? finishingDate;
  String state;

  Trip(
      {required this.tripId,
        required this.title,
        required this.description,
        required this.price,
        required this.creationDate,
        this.startingDate,
        this.finishingDate,
        required this.state});

  Map<String, Object?> toJson() => {
    TripFields.tripId: tripId,
    TripFields.title: title,
    TripFields.description: description,
    TripFields.price: price,
    TripFields.creationDate: creationDate.toIso8601String(),
    TripFields.startingDate: startingDate?.toIso8601String(),
    TripFields.finishingDate: finishingDate?.toIso8601String(),
    TripFields.state: state
  };

  Trip copy({
    int? id,
    String? title,
    String? description,
    String? price,
    DateTime? creationDate,
    DateTime? startingDate,
    DateTime? finishingDate,
    String? state,
  }) =>
    Trip(
      tripId: id ?? tripId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      creationDate: creationDate ?? this.creationDate,
      startingDate: startingDate ?? this.startingDate,
      finishingDate: finishingDate ?? this.finishingDate,
      state: state ?? this.state,
    );

  static Trip fromJson(Map<String, Object?> json) => Trip(
    tripId: json[TripFields.tripId] as int,
    title: json[TripFields.title] as String,
    description: json[TripFields.description] as String,
    price: json[TripFields.price] as String,
    creationDate: DateTime.parse(json[TripFields.creationDate] as String),
    startingDate: json[TripFields.startingDate] == null ? null : DateTime.parse(json[TripFields.startingDate] as String),
    finishingDate: json[TripFields.finishingDate] == null ? null : DateTime.parse(json[TripFields.finishingDate] as String),
    state: json[TripFields.state] as String,

  );

}