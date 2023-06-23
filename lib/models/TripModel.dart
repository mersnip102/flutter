/// TripModel.dart
import 'dart:convert';

Trip tripFromJson(String str) {
  final jsonData = json.decode(str);
  return Trip.fromMap(jsonData);
}

String tripToJson(Trip data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Trip {
  String id;
  String name;
  String destination;
  String startDate;
  String endDate;
  String risk;
  String description;
  String vehicle;
  String contribute;

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.risk,
    required this.description,
    required this.vehicle,
    required this.contribute,
  });

  // ignore: unnecessary_new
  factory Trip.fromMap(Map<String, dynamic> json) => new Trip(
        id: json["id"],
        name: json["name"],
        destination: json["destination"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        risk: json["risk"],
        description: json["description"],
        vehicle: json["vehicle"],
        contribute: json["contribute"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "destination": destination,
        "startDate": startDate,
        "endDate": endDate,
        "risk": risk,
        "description": description,
        "vehicle": vehicle,
        "contribute": contribute,
      };

  
}